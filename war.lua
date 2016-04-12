function Attack_6() {
	if (IsBuf("Яростный выпад!")) then 
		SpellUse("Яростный выпад");	
	end
	if (IsBuf("Прилив крови")) then 
		SpellUse("Зверский удар");	
	end
	if (GetMana('player') >= 30) then
		SpellUse("Зверский удар");
	end
	if (GetMana('player') < 30) then
		SpellUse("Кровожадность");
	end
	if (GetMana('player') >= 30) then
		SpellUse("Зверский удар");
	end
}
