-- module Data.Foldable
local Foldable = {}

Foldable.foldrArray = function (f)
  return function (init)
    return function (xs)
      local acc = init
      local len = #xs
      for i = len - 1, 0, -1 do
        acc = f(xs[i+1])(acc)
      end
      return acc
    end
  end
end

Foldable.foldlArray = function (f)
  return function (init)
    return function (xs)
      local acc = init
      local len = #xs
      for i = 0, len do
        acc = f(acc)(xs[i+1])
      end
      return acc
    end
  end
end

return Foldable
