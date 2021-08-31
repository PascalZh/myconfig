if (not vim.g.animation_fps) then
  vim.g.animation_fps = 120
end
if (not vim.g.animation_duration) then
  vim.g.animation_duration = 300
end
if (not vim.g.animation_ease_func) then
  vim.g.animation_ease_func = "quad"
end

local M = {DEBUG = false}

---@return number time in milliseconds
local function time()
  return vim.fn.reltimefloat(vim.fn.reltime()) * 1000
end

local function dprint(str)
  if (M.DEBUG) then
    print(str)
  end
end

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

function Animate:_run_next_task()
  self.task_idx = self.task_idx + 1
  if (self.task_idx <= #self.task_queue) then
    self.task_queue[self.task_idx]()
  end
end

---@param update fun(cur_state:number, next_state:number):number a function that update current state and do the actual 'animation'
---@param options table support ease_func, duration and delay options
function Animate:animate(start_state, end_state, update, options)
  local options = options or {}
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
  local duration = options.duration or vim.g.animation_duration

  local function task()
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
      dprint(vim.inspect{elapsed_time, next_state, duration, start_state, delta_state})
      cur_state = update(cur_state, next_state)
    end))
  end

  self.task_queue[#self.task_queue+1] = task
  return self
end

function Animate:call_func(func, options)
  local options = options or {}

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
local resize_vertically_update = make_resize_update("vertical resize ")
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
    options)
end

function Animate:resize_vertically_delta(delta, options)
  return self:animate(
    function () return vim.fn.winwidth(0) end,
    function () return vim.fn.winwidth(0) +
      ((type(delta) == 'function') and delta() or delta) end,
    resize_vertically_update,
    options)
end
-- }}}

-- Ease functions {{{

---@param y_ number end state - start state
---@param t_ number duration
---@param t  number current time
local function ease_func_linear(y_, t_, t)
  return y_ * (t / t_)
end

local function ease_func_quad(y_, t_, t)
  local u = t / t_
  return - y_ * u * (u - 2)
end

local function ease_func_cubic(y_, t_, t)
  local v = t / t_ - 1
  return y_ * (v * v * v + 1)
end

local function ease_func_sine(y_, t_, t)
  local u = t / t_
  return y_ * 0.5 * (1 - math.cos(math.pi * u))
end

Animate.ease_funcs = {
  linear = ease_func_linear,
  quad = ease_func_quad,
  cubic = ease_func_cubic,
  sine = ease_func_sine
}

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
