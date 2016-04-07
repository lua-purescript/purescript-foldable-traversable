-- module Data.Traversable
local Traversable = {}

Traversable.traverseArrayImpl = (function ()
  function Cont (fn)
	local ret = {}
    ret.fn = fn
	return ret
  end

  local emptyList = {}

  function consList (x)
    return function (xs)
      return { head = x, tail = xs }
    end
  end

  function listToArray (list)
    local arr = {}
    while list ~= nil and list.head ~= nil do
      arr[#arr+1] = list.head
      list = list.tail
    end
    return arr
  end

  return function (apply)
    return function (map)
      return function (pure)
        return function (f)
          local buildFrom = function (x, ys)
            return apply(map(consList)(f(x)))(ys)
          end

          local go = function (acc, currentLen, xs)
            if currentLen == 0 then
              return acc
            else
              local last = xs[currentLen]
              return Cont(function ()
                return go(buildFrom(last, acc), currentLen - 1, xs)
              end)
            end
          end

          return function (array)
            local result = go(pure(emptyList), array.length, array)
            while result.fn ~= nil do
              result = result.fn()
            end

            return map(listToArray)(result)
          end
        end
      end
    end
  end
end)()

return Traversable
