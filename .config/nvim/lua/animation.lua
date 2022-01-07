if not vim.g.animation_fps then
  -- 90Hz is OK in my machine, but 60Hz is not enough
  -- It doesn't mean the true fps, you should try it in your machine
  vim.g.animation_fps = 90
end
if not vim.g.animation_duration then
  vim.g.animation_duration = 350
end
if not vim.g.animation_ease_func then
  vim.g.animation_ease_func = 'quad'
end

local M = {DEBUG = false}

---@return number Time in milliseconds
local function time()
  return vim.loop.hrtime() / 1000000
end

local function dprint(str)
  if M.DEBUG then
    print(str)
  end
end

local prev_state = 0
local function dprint_state(elapsed_time, next_state)
  if (M.DEBUG) then
    dprint(string.format('{ elapsed_time, next_state, diff_state } = {% 6.1f, % 8.2f, % 4.2f }', elapsed_time, next_state, next_state - prev_state))
    prev_state = next_state
  end
end

-- NOTICE that most methods of Animate will not execute immediately, instead it
-- will push a task to the object. Animate:start will start the task queue from
-- start.
local Animate = {}

function Animate:new()
  local obj = {
    task_idx = 1,
    task_queue = {},
    epsilon = 0.01
  }
  self.__index = self
  setmetatable(obj, self)
  return obj
end

function Animate:start()
  if (#self.task_queue > 0) then
    self.task_idx = 1
    self.task_queue[self.task_idx]()
  end
end

-- Any task must call _run_next_task at the end
function Animate:_run_next_task()
  self.task_idx = self.task_idx + 1
  if (self.task_idx <= #self.task_queue) then
    self.task_queue[self.task_idx]()
  end
end

---@param update fun(cur_state:number, next_state:number):number A function that update current state and do the actual 'animation'
---@param options table Support ease_func, duration and delay options
function Animate:animate(start_state, end_state, update, options)
  local options = options or {}

  local function task()
    local duration = options.duration or vim.g.animation_duration
    local ease_func
    if (options.ease_func) then
      if (type(options.ease_func) == 'string') then
        ease_func = Animate.ease_funcs[options.ease_func]
      elseif (type(options.ease_func) == 'function') then
        ease_func = options.ease_func
      end
    else
      ease_func = Animate.ease_funcs[vim.g.animation_ease_func]
    end
    if (type(start_state) == 'function') then
      start_state = start_state()
    end
    if (type(end_state) == 'function') then
      end_state = end_state()
    end

    local timer = vim.loop.new_timer()
    local delta_state = end_state - start_state
    local cur_state = start_state
    local interval = 1000 / vim.g.animation_fps
    local delay = options.delay or interval
    dprint(string.format('duration = %s, start_state = %s, end_state = %s', duration, start_state, end_state))

    local start_time
    timer:start(delay, interval, vim.schedule_wrap(function ()
      if (not start_time) then
        start_time = time()
        return
      end

      local elapsed_time = time() - start_time
      -- stop the timer and start the next task in the queue
      if (elapsed_time > duration) then
        timer:stop()

        if (math.abs(cur_state - end_state) > self.epsilon) then
          update(cur_state, end_state)  -- ensure end_state is reached
        end

        self:_run_next_task()
      end

      -- calcute next_state corresponds to current time, and update
      local next_state = ease_func(delta_state, duration, elapsed_time) + start_state
      dprint_state(elapsed_time, next_state)

      cur_state = update(cur_state, next_state)
    end))
  end

  self.task_queue[#self.task_queue+1] = task
  return self
end

function Animate:call_func(func, options)
  options = options or {}

  local function func_wrapper()
    func()
    self:_run_next_task()
  end

  local task

  if (options.delay) then
    task = function () vim.defer_fn(func_wrapper, options.delay) end
  else
    task = func_wrapper
  end

  self.task_queue[#self.task_queue+1] = task
  return self
end

function Animate:cmd(cmd, options)
  return self:call_func(function () vim.cmd(cmd) end, options)
end

-- Predefined 'update' functions {{{
local function make_scroll_update(action)
  return function (cur_state, next_state)
    local diff = math.floor(next_state - cur_state)
    if (diff >= 1) then
      vim.cmd('execute "normal! '..tostring(diff)..action..'"')
      return cur_state + diff
    else
      return cur_state
    end
  end
end

local function make_resize_update(cmd)
  return function (cur_state, next_state)
    next_state = math.floor(next_state)
    local diff = next_state - cur_state
    if (diff ~= 0) then
      vim.cmd("execute '"..cmd..tostring(next_state).."'")
      return next_state
    else
      return cur_state
    end
  end
end

local scroll_up_update = make_scroll_update("\\<C-e>")
local scroll_down_update = make_scroll_update("\\<C-y>")

local resize_update = make_resize_update("resize ")
local vresize_update = make_resize_update("vertical resize ")
-- }}}

-- Common api {{{
function Animate:scroll_up(delta, options)
  return self:animate(0, delta, scroll_up_update, options)
end

function Animate:scroll_down(delta, options)
  return self:animate(0, delta, scroll_down_update, options)
end

function Animate:resize_delta(delta, options)
  return self:animate(
    function () return vim.fn.winheight(0) end,
    function () return vim.fn.winheight(0) +
      ((type(delta) == 'function') and delta() or delta) end,
    resize_update,
    options
  )
end

-- v means vertically
function Animate:vresize_delta(delta, options)
  return self:animate(
    function () return vim.fn.winwidth(0) end,
    function () return vim.fn.winwidth(0) +
      ((type(delta) == 'function') and delta() or delta) end,
    vresize_update,
    options
  )
end

-- @param size float A percentage of the view width or height
-- @param file string Default: ''.
-- @param direction string Could be 'leftabove', 'rightbelow', ... see :leftabove in the help of vim. Default: ''.
function Animate:split(size, file, direction, options)
  self:cmd((direction or '')..'0new | redraw')
    :resize_delta(function () return math.floor(vim.o.lines * (size or 0.5)) - 2 end, options)
  if file then self:cmd('e '..file..' | redraw') end
  return self
end

-- @param size float A percentage of the view width or height
-- @param file string Default: ''.
-- @param direction string Could be 'leftabove', 'rightbelow', ... see :leftabove in the help of vim. Default: ''.
function Animate:vsplit(size, file, direction, options)
  self:cmd((direction or '')..'vertical 0new | redraw')
    :vresize_delta(function () return math.floor(vim.o.columns * (size or 0.5)) end, options)
  if file then self:cmd('e '..file..' | redraw') end
  return self
end

-- }}}

-- Ease functions {{{

Animate.ease_funcs = {}

---@param y_ number end state - start state
---@param t_ number duration
---@param t  number current time
function Animate.ease_funcs.linear(y_, t_, t)
  return y_ * (t / t_)
end

function Animate.ease_funcs.quad(y_, t_, t)
  local u = t / t_
  return - y_ * u * (u - 2)
end

function Animate.ease_funcs.cubic(y_, t_, t)
  local v = t / t_ - 1
  return y_ * (v * v * v + 1)
end

function Animate.ease_funcs.sine(y_, t_, t)
  local u = t / t_
  return y_ * 0.5 * (1 - math.cos(math.pi * u))
end

-- }}}

-- Predefined Animate instances and module functions{{{
local anim_scroll_up_half = Animate:new()
  :scroll_up(function () return vim.fn.winheight(0) / 2 end)
local anim_scroll_up = Animate:new()
  :scroll_up(function () return vim.fn.winheight(0) end)

local anim_scroll_down_half = Animate:new()
  :scroll_down(function () return vim.fn.winheight(0) / 2 end)
local anim_scroll_down = Animate:new()
  :scroll_down(function () return vim.fn.winheight(0) end)

function M.scroll_up_half()
  anim_scroll_up_half:start()
end
function M.scroll_up()
  anim_scroll_up:start()
end

function M.scroll_down_half()
  anim_scroll_down_half:start()
end
function M.scroll_down()
  anim_scroll_down:start()
end

-- }}}

M.Animate = Animate
return M
