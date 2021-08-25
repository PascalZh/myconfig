vim.cmd [[
if !exists("g:animation_fps")
  let g:animation_fps = 90
endif
if !exists("g:animation_duration")
  let g:animation_duration = 300
endif
if !exists("g:animation_ease_func")
  let g:animation_ease_func = "quad"
endif
]]

local M = {}

-- @return time in milliseconds
local function time()
  return vim.fn.reltimefloat(vim.fn.reltime()) * 1000
end

local Animate = {}

function Animate:new()
  local obj = {
    task_idx = -1,
    task_queue = {},
    epsilon = 0.01  -- TODO epsilon better be calculated with interval and derivative informations
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

-- @param update a function that update current state and do the actual 'animation'
function Animate:animate(start_state, end_state, update, duration, ease_func)
  local function task()
    if (type(start_state) == 'function') then
      start_state = start_state()
    end
    if (type(end_state) == 'function') then
      end_state = end_state()
    end

    local timer = vim.loop.new_timer()
    local start_time = time()
    local interval = 1000 / vim.g.animation_fps
    local delta_state = end_state - start_state
    local cur_state = start_state

    timer:start(interval, interval, vim.schedule_wrap(function ()
      print('timer invoked cur_state = '..tostring(cur_state))
      local elapsed_time = time() - start_time

      -- calcute next_state corresponds to current time, and update
      local next_state = ease_func(delta_state, duration, elapsed_time) + start_state
      cur_state = update(cur_state, next_state)

      -- stop the timer and start the next task in the queue
      if (elapsed_time > duration) then
        timer:stop()

        if (math.abs(cur_state - end_state) > self.epsilon) then
          update(cur_state, end_state)  -- ensure end_state is reached
        end

        self.task_idx = self.task_idx + 1
        if (self.task_idx <= #self.task_queue) then
          self.task_queue[self.task_idx]()
        end
      end
    end))
  end

  self.task_queue[#self.task_queue+1] = task
  return self
end

function Animate:animate_helper_1(start_state, end_state, update, duration)
  return self:animate(start_state, end_state, update, duration,
    Animate.ease_funcs[vim.g.animation_ease_func])
end
function Animate:animate_helper_2(start_state, end_state, update)
  return self:animate(start_state, end_state, update,
    vim.g.animation_duration, Animate.ease_funcs[vim.g.animation_ease_func])
end

function Animate:call_func(func, timeout)

  local function func_wrapper()
    func()
    self.task_idx = self.task_idx + 1
    if (self.task_idx <= #self.task_queue) then
      self.task_queue[self.task_idx]()
    end
  end

  local task

  if (timeout) then
    task = function () vim.defer_fn(func_wrapper, timeout) end
  else
    task = func_wrapper
  end

  self.task_queue[#self.task_queue+1] = task
  return self
end

function Animate:cmd(cmd, timeout)
  return self:call_func(function () vim.cmd(cmd) end, timeout)
end

-------------------------- predefined 'update' functions -----------------------

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

local scroll_up_update = make_scroll_update("\\<C-e>")
local scroll_down_update = make_scroll_update("\\<C-y>")

function Animate:scroll_up(delta)
  return self:animate_helper_2(0, delta, scroll_up_update)
end

function Animate:scroll_down(delta)
  return self:animate_helper_2(0, delta, scroll_down_update)
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

local resize_update = make_resize_update("resize ")
local resize_vertically_update = make_resize_update("vertical resize ")

function Animate:resize_delta(delta)
  if (type(delta) == 'function') then
    delta = delta()
  end
  return self:animate_helper_2(
    function () return vim.fn.winheight(0) end,
    function () return vim.fn.winheight(0) + delta end,
    resize_update)
end

function Animate:resize_vertically_delta(delta)
  if (type(delta) == 'function') then
    delta = delta()
  end
  return self:animate_helper_2(
    function () return vim.fn.winwidth(0) end,
    function () return vim.fn.winwidth(0) + delta end,
    resize_vertically_update)
end

-- ease functions {{{

-- @param y_ end state - start state
-- @param t_ duration
-- @param t  current time
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

M.Animate = Animate
return M
