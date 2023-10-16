
Locales = {}

function _(str, ...) -- Translate string

	if Locales[Config.defaultlang] ~= nil then

		if Locales[Config.defaultlang][str] ~= nil then
			return string.format(Locales[Config.defaultlang][str], ...)
		else
			return 'Translation [' .. Config.defaultlang .. '][' .. str .. '] does not exist'
		end

	else
		return 'Locale [' .. Config.defaultlang .. '] does not exist'
	end

end

function _U(str, ...) -- Translate string first char uppercase
	return (tostring(_(str, ...):gsub("^%l", string.upper)))
end

-- _P("{killer} killed {victim}", {killer = "Bob", victim = "Joe"})
-- returns "Bob killed Joe"
-- No spaces or special chars in parameter name, just alphanumerics.
function _P(str, params) -- Translate string using parameters table with named keys
	if Locales[Config.defaultlang] ~= nil then
		if Locales[Config.defaultlang][str] ~= nil then
			return (string.gsub(Locales[Config.defaultlang][str], '{(%w+)}', params))
		else
			return 'Translation [' .. Config.defaultlang .. '][' .. str .. '] does not exist'
		end
	else
		return 'Locale [' .. Config.defaultlang .. '] does not exist'
	end 
end

function _UP(str, params) -- Translate string using parameters table with named keys, first char uppercase
	return (tostring(_P(str, params)):gsub("^%l", string.upper))
end
