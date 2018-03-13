    function inTable( table, value )
      if table ~= nil then for i,x in pairs(table) do if x == value then return true end end end
      return false
    end


    function clearnewitems( itype )
        local types = {"weapon_mods", "masks", "materials", "textures", "colors"}
        if not itype then itype = "all" end
        if type(itype) == "table" then types = itype end
        if itype == "all" or type(itype) == "table" then
          for i = 1, #types do clearnewitems(types[i]) end
          return
        elseif not inTable(types, itype) then return end
        for global_value, categories in pairs( Global.blackmarket_manager.inventory ) do
                if categories[itype] then
                      for mat_id,amount in pairs( categories[itype] ) do
                    managers.blackmarket:remove_new_drop( global_value, itype, mat_id )
                end
            end
        end
    end


clearnewitems()