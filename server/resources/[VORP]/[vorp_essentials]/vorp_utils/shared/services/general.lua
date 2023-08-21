GeneralAPI = {}

function GeneralAPI:CreateClass(create)
   local _class = {}
   _class.class = {}

   function _class:constructor(vars)
      self.class = vars
   end

   function _class:registerFunctions(functions)
      for key, value in pairs(functions) do
         self.class[key] = value
      end

      return functions
   end

   local raw_functions = create(function(setupvars)
      _class:constructor(setupvars)
   end)

   if raw_functions ~= nil then
      _class:registerFunctions(raw_functions)
   end

   return _class.class
end
