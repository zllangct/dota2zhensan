function foujuequanzhang_01(keys)
	-- body
	local group = keys.target_entities

	for i,unit in pairs(group) do
		if unit:IsAlive() then
			unit:Purge(true,true,true,false,true)
		end
	end
end