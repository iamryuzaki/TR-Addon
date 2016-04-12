function Attack_6() 
	if (IsDeBuf('Удар колосса')) then
		SpellUse("Удар громовержца");
		SpellUse("Рев дракона");
	end
	if (IsBuf("Яростный выпад!")) then 
		SpellUse("Удар колосса");
		SpellUse("Яростный выпад");	
	end
	if (IsBuf("Прилив крови")) then 
		SpellUse("Удар колосса");
		SpellUse("Зверский удар");	
	end
	SpellUse("Кровожадность");
	SpellUse("Удар громовержца");
	SpellUse("Рев дракона");
	if (GetMana('player') >= 30) then
		SpellUse("Зверский удар");
	end
end


function Attack6()
	SetTimeout('Attack6',0.5);
	A_Atack(6);
end


local faze = 0;
function Attack_8() 
	if (IsDeBuf("Лунный огонь") == false)
		SpellUse("Лунный огонь");
	end 
	if (IsDeBuf("Солнечный огонь") == false)
		SpellUse("Солнечный огонь");
	end
	
	if (IsBuf("Лунное затмение"))
	    faze = 1;
		SpellUse("Звездопад");
		SpellUse("Звездный поток");
		if (IsCasting()) then return; end
		
		SpellUse("Звездный огонь");
		
	end
	if (IsBuf("Солнечное затмение"))
	    faze = 0;
		SpellUse("Звездный поток");
		SpellUse("Гнев");
	end
	if (IsBuf("Лунное затмение") == false and IsBuf("Солнечное затмение") == false)
	
	    if (faze == 0) then
			SpellUse("Гнев");
		else
			SpellUse("Звездный огонь");
		end
	end
end
