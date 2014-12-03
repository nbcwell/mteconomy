bank = {}
local accounts = {}

function bank.updateBalance(name, amount)
    accounts[name].balance = amount
	bank.saveAccounts()
	end
	
function bank.getBalance(name)
    return accounts[name].balance
	end

function bank.saveAccounts()
	local output = io.open(minetest.get_worldpath() .. "/accounts", "w")
	output:write(minetest.serialize(accounts))
	io.close(output)
end

function bank.loadAccounts()
    local input = io.open(minetest.get_worldpath() .. "/accounts", "r")
    if input then
	    accounts = minetest.deserialize(input:read("*l"))
	    io.close(input)
    end
end

function bank.openNewAccount(name, initial_deposit)
    accounts[name] = {}
    accounts[name].balance = initial_deposit
end

function countPlayerInventoryItems(inventory, item_name)
    return countItems(inventory, "main", item_name)
end

function countItems(inventory, list_name, item_name)
    count = 0
    for i = 0, inventory:get_size(list_name), 1 do
        stack = inventory:get_stack(list_name, i)
        if stack:get_name() == item_name then
            count = count + stack:get_count()
        end
    end
    
    return count
end

-- Init

bank.loadAccounts()

minetest.register_node("mteconomy:atm", {
        tiles = {"atm.png"},
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3},
		
		on_rightclick = function(pos, node, player, itemstack, pointed_thing)
            name = player:get_player_name()
            balance = bank.getBalance(name)
            player_balance = countPlayerInventoryItems(player:get_inventory(), "mteconomy:coin")
            minetest.show_formspec(name, "youkai_economy:atm_form", "size[8,5.6]"..
                "label[0.25,0.2;Welcome, "..name..".]"..
                "label[0.25,0.6;Current Account Balance: "..balance.."]"..
                "label[0.25,1.0;Current Inventory Balance: "..player_balance.."]"..
                "field[0.256,2.5;8,1;nodename2;for:;]"..
                "field[0.256,3.5;8,1;amount1;Amount of first kind of node:;]"..
                "field[0.256,4.5;8,1;amount2;Amount of second kind of node:;]"..
                "button_exit[3.1,5;2,1;button;Proceed]")
			return nil
		end,
        
        on_construct = function(pos)
           local meta = minetest.env:get_meta(pos)         
		   meta:set_string("infotext", "ATM")
      end,
      
      on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
      end,
})

minetest.register_on_joinplayer(function(player)
									name = player:get_player_name()
								    if accounts[name] == nil then
						                bank.openNewAccount(name, 0)
						            end
                                end
)

minetest.register_on_player_receive_fields(function(player, formname, fields)
                if formname == "mteconomy:atm_form" then -- This is your form name
                    print("Player "..player:get_player_name().." submitted fields "..dump(fields))
                    print("word")
                end
            end
)
