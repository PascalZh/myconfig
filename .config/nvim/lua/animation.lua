if not vim.g.animation_fps then
  -- 90Hz is OK in my machine, but 60Hz is not enough
  -- It doesn't mean the true fps, you should try it in your machine
  vim.g.animation_fps = 90
end
if not vim.g.animation_duration then vim.g.animation_duration = 350 end
if not vim.g.animation_ease_func then vim.g.animation_ease_func = 'quad' end

local M = {DEBUG = false}

-- helper local functions {{{
---@return number Time in milliseconds
local function time_ms() return vim.loop.hrtime() / 1000000 end

local function dprint(str) if M.DEBUG then print(str) end end

local function dprint_state(elapsed_time, cur_state, next_state)
  if (M.DEBUG) then
    dprint(string.format('{ elapsed_time, cur_state, next_state} = {% 6.1f, % 8.2f, % 4.2f }', elapsed_time, cur_state,
                         next_state))
  end
end

local function extend_opt(o)
  o = o or {}
  if (o.ease_func) then
    if (type(o.ease_func) == 'string') then
      o.ease_func = M.ease_funcs[o.ease_func]
    elseif (type(o.ease_func) == 'function') then
      o.ease_func = o.ease_func
    end
  else
    o.ease_func = M.ease_funcs[vim.g.animation_ease_func]
  end
  o.duration = o.duration or vim.g.animation_duration
  o.fps = o.fps or vim.g.animation_fps
  return o
end

-- }}}

function M.run(func)
  local co = coroutine.wrap(func)
  co()
end

M.co = {} -- co module contains functions that should be called in a coroutine

---@param update fun(cur_state:number, next_state:number):number A function that update current state and do the actual 'animation'
---@param anim_opt table Support ease_func, duration and delay options
function M.co.animate(start_state, end_state, update, anim_opt)
  anim_opt = extend_opt(anim_opt)
  local duration = anim_opt.duration
  local ease_func = anim_opt.ease_func
  local interval = 1000 / anim_opt.fps
  local delay = anim_opt.delay or interval

  local co = coroutine.running()

  local timer = vim.loop.new_timer()

  dprint(string.format('duration = %s, start_state = %s, end_state = %s', duration, start_state, end_state))

  local delta_state = end_state - start_state
  local cur_state = start_state
  local start_time
  timer:start(delay, interval, vim.schedule_wrap(function()
    if (not start_time) then -- first iteration, save the start_time
      start_time = time_ms()
      return
    end

    local elapsed_time = time_ms() - start_time

    -- stop the timer and start the next task in the queue
    if (elapsed_time > duration) then
      timer:stop()

      update(cur_state, end_state) -- ensure end_state is reached

      coroutine.resume(co)
    else
      -- calcute next_state corresponds to current time, and update
      local next_state = ease_func(delta_state, duration, elapsed_time) + start_state

      dprint_state(elapsed_time, cur_state, next_state)

      cur_state = update(cur_state, next_state)
    end
  end))

  coroutine.yield()
end

-- Predefined 'update' functions {{{
local function make_scroll_update(action)
  return function(cur_state, next_state)
    local diff = math.floor(next_state - cur_state)
    if (diff >= 1) then
      vim.cmd('execute "normal! ' .. tostring(diff) .. action .. '"')
      return cur_state + diff
    else
      return cur_state
    end
  end
end

local function make_resize_update(cmd)
  return function(cur_state, next_state)
    next_state = math.floor(next_state)
    local diff = next_state - cur_state
    if (diff ~= 0) then
      vim.cmd('execute \'' .. cmd .. tostring(next_state) .. '\'')
      return next_state
    else
      return cur_state
    end
  end
end

local scroll_up_update = make_scroll_update('\\<C-e>')
local scroll_down_update = make_scroll_update('\\<C-y>')

local resize_update = make_resize_update('resize ')
local vresize_update = make_resize_update('vertical resize ')
-- }}}

-- Common api

function M.co.scroll_up(delta, anim_opt) M.co.animate(0, delta, scroll_up_update, anim_opt) end

function M.co.scroll_down(delta, anim_opt) M.co.animate(0, delta, scroll_down_update, anim_opt) end

function M.co.resize_delta(delta, anim_opt)
  M.co.animate(vim.fn.winheight(0), vim.fn.winheight(0) + delta, resize_update, anim_opt)
end

function M.co.vresize_delta(delta, anim_opt)
  M.co.animate(vim.fn.winwidth(0), vim.fn.winwidth(0) + delta, vresize_update, anim_opt)
end

-- @param size float A percentage of the view width or height
-- @param file string Default: ''.
-- @param direction string Could be 'leftabove', 'rightbelow', ... see :leftabove in the help of vim. Default: ''.
function M.co.split(size, file, direction, anim_opt)
  vim.cmd((direction or '') .. ' 0sp ' .. (file or ''))
  M.co.resize_delta(math.floor(vim.o.lines * (size or 0.5)) - 2, anim_opt)
  vim.cmd('redraw')
end

-- @param size float A percentage of the view width or height
-- @param file string Default: ''.
-- @param direction string Could be 'leftabove', 'rightbelow', ... see :leftabove in the help of vim. Default: ''.
function M.co.vsplit(size, file, direction, anim_opt)
  vim.cmd((direction or '') .. ' 0vs ' .. (file or ''))
  M.co.vresize_delta(math.floor(vim.o.columns * (size or 0.5)) - 2, anim_opt)
  vim.cmd('redraw')
end

function M.scroll_up() M.run(function() M.co.scroll_up(vim.fn.winheight(0)) end) end

function M.scroll_up_half() M.run(function() M.co.scroll_up(vim.fn.winheight(0) / 2) end) end

function M.scroll_down() M.run(function() M.co.scroll_down(vim.fn.winheight(0)) end) end

function M.scroll_down_half() M.run(function() M.co.scroll_down(vim.fn.winheight(0) / 2) end) end

function M.split(size, file, direction, anim_opt) M.run(function() M.co.split(size, file, direction, anim_opt) end) end

function M.vsplit(size, file, direction, anim_opt) M.run(function() M.co.vsplit(size, file, direction, anim_opt) end) end

-- Ease functions {{{
M.ease_funcs = {}

---@param y_ number end state - start state
---@param t_ number duration
---@param t  number current time
function M.ease_funcs.linear(y_, t_, t) return y_ * (t / t_) end

function M.ease_funcs.quad(y_, t_, t)
  local u = t / t_
  return -y_ * u * (u - 2)
end

function M.ease_funcs.cubic(y_, t_, t)
  local v = t / t_ - 1
  return y_ * (v * v * v + 1)
end

function M.ease_funcs.sine(y_, t_, t)
  local u = t / t_
  return y_ * 0.5 * (1 - math.cos(math.pi * u))
end
-- }}}

return M
