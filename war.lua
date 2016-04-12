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
