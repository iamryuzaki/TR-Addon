print('Hallow! Addon TheRyuzaki is Enabled');

function Split(str, sep)
	local li = 0;
	local arr = {};
	for word in string.gmatch(str, '([^'..sep..']+)') do
		arr[li] = word;
		li = li + 1;
	end
	return arr;
end

function RMT(text)
	RunMacroText(text);
end

function GetUnit(unit, target) 
	if (unit) then return unit; end
	if not target then return 'player'; else return 'target'; end
end

function Log(msg)
	print('|cFFFF0000'..'[TheRyuzaki]: |r'..msg);
end



local player_class = UnitClass("player");
local player_numspec, player_spec = GetSpecializationInfo(GetSpecialization());
--RMT('/с Здравствуйте, Я <'..GetUnitName("player")..'> ['..player_class..'] '.. UnitLevel('player')..'го уровня в спеке ['..player_spec..']');




Log('Addon TheRyuzaki has end init.');



-- Используем способность
-- name - имя способности в той лаколизации в которой у вас клиент(Обязательное поле)
-- target - цель заклинания. Если не указано поле то целью является выделеная цель(Не обязательное поле)
function SpellUse(name)
	local cd = GetSpellCooldown(name);
	if (cd == 0) then
		RMT('/cast '..name);
	end
end

-- Проверят - кастует ли юнит
-- name - название способности(Необятательное поле) - если проверятете на любой кастуемый спел то поставьте nil
-- target - цель заклинания. Если не указано поле то целью является сам игрок(Не обязательное поле)
function IsCasting(name, target)
	target = GetUnit(target);
	local spell, _, _, _, _, endTime = UnitCastingInfo(target)
	local spell2, _, _, _, _, endTime2 = UnitChannelInfo(target)
	if (spell or spell2) then 
		 if (not name or name == spell or name == spell2) then return true; end
	end
	return false;
end

-- Проверяет - вестли баф
-- name - имя способности в той лаколизации в которой у вас клиент(Обязательное поле)
-- target - цель заклинания. Если не указано поле то целью является сам игрок(Не обязательное поле)
-- my - проверяет чей баф. И будет возвращать true только если найденый баф является вашим.(Не обязательное поле)
function IsBuf(name, target, my)
	target = GetUnit(target);
	for i=1,40 do 
		local D, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 = UnitBuff(target,i);
		if (D and D == name) then
			if ((arg8 == 'player' and my) or not my) then
				return arg4;
			end
		end 
	end
	return false;
end

-- Проверяет - вестли баф
-- name - имя способности в той лаколизации в которой у вас клиент(Обязательное поле)
-- target - цель заклинания. Если не указано поле то целью является выделеная цель(Не обязательное поле)
-- my - проверяет чей баф. И будет возвращать true только если найденый баф является вашим.(Не обязательное поле)
function IsDeBuf(name, target, my)
	target = GetUnit(target, true);
	for i=1,40 do 
		local D, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 = UnitDebuff(target,i);
		if (D and D == name) then 
			if ((arg8 == 'player' and my) or not my) then
				return arg4;
			end
		end 
	end
	return false;
end

-- Проверяет - Возвращает колличество здоровья (процент)
-- target - цель заклинания. Если не указано поле то целью является выделеная цель(Не обязательное поле)
function GetHeal(target) 
	target = GetUnit(target, true);
	return UnitHealth(target) * 100 / UnitHealthMax(target);
end

-- Проверяет - Возвращает колличество маны (процент)
-- target - цель заклинания. Если не указано поле то целью является выделеная цель(Не обязательное поле)
function GetMana(target) 
	target = GetUnit(target, true);
	return UnitMana(target) * 100 / UnitManaMax(target);
end


local Tick = {};
local i_OnUpdate = 0;
local i_interval = 0.25;
local lastint = 0;
local function OnUpdate(self,elapsed)
    i_OnUpdate = i_OnUpdate + elapsed
    if i_OnUpdate >= i_interval then
		i_OnUpdate = 0;
		Update();
    end
end
local f = CreateFrame("frame");
f:SetScript("OnUpdate", OnUpdate);
local Cron = {};
local tmp_Cron = {};
function SetTimeout(name, timeout)
	Cron[name] = timeout;
	tmp_Cron[name] = 0;
end
function DelTimeout(name)
	Cron[name] = nil;
	tmp_Cron[name] = nil;
end
function Update()
	local GC = true;
	for i, v in pairs(Cron) do
		if (Cron[i] == nil) then
		else 
			if (Cron[i] == tmp_Cron[i]) then
				Cron[i] = nil;
				tmp_Cron[i] = nil;
				_G[i]();
			else
				GC = false;
			end
			tmp_Cron[i] = tmp_Cron[i] + 0.25;
		end
	end
	for i, v in pairs(Cron) do
		if (Cron[i] == nil) then else
		GC = false;
		end
	end
	if (GC) then
		Cron = {};
		tmp_Cron = {};
	end
end


function A_Atack(id)
	if not id then
		print('Error! Not id functions.');
	else 
		if (_G['Attack_'..id]) then
			_G['Attack_'..id]();
		else
			print('Error! Undefind function id:'..id);
		end
	end
end



-- Custom functions
function Atack1(id)
	SetTimeout('Atack1',0.5);
	A_Atack(1);
end
function Attack_1() 
	if (IsBuf('Чародейская гениальность') == false) then SpellUse('Чародейская гениальность'); end
	SpellUse('Возгорание');
	if (IsDeBuf('Пироман', 'target', true)) then else SpellUse('Живая бомба'); end
	if (IsBuf('Огненная глыба!') or IsBuf('Величие разума')) then SpellUse('Огненная глыба'); end
	SpellUse('Пламенный взрыв');
	SpellUse('Ожог');
end

function Attack2()
	SetTimeout('Attack2',0.5);
	A_Atack(2);
end
function Attack_2()
	SpellUse('Ледяной столп'); -- В первую очередь если не в КД то юзаем Ледяной столп
	if (GetHeal('target') <= 35) then 
		SpellUse('Жнец душ');  -- если у противника мение или ровно 35% здаровья то юзаем Жнец душ
	end	
	if (IsDeBuf('Кровавая чума', 'target', true)) then 
	else
		SpellUse('Вспышка болезни'); -- Если на противнике нету Кровавой чумы то пытаемся вешать сначало Вспышка болезни
		SpellUse('Удар чумы');
	end
	if (IsBuf('Морозная дымка') and IsBuf('Машина для убийств') == false and GetMana('player') <= 50) then
		SpellUse('Воющий ветер'); -- если есть морозная дымка и и нету машины для убийств то юзаем воющий ветер
	end
	if (GetMana('player') >= 80) then SpellUse('Ледяной удар'); end
	SpellUse('Уничтожение');
	if (GetMana('player') >= 35) then SpellUse('Ледяной удар'); end
	if (IsBuf('Морозная дымка') and IsBuf('Машина для убийств') == false) then
		SpellUse('Воющий ветер'); -- если есть морозная дымка и и нету машины для убийств то юзаем воющий ветер
	end
	SpellUse('Воющий ветер'); -- Если нету на ледяной удар рун то используем Воющий ветер
	SpellUse('Зимний горн'); -- Если мало рунической энергии то используем Зимний горн(+20 к энергии)
	SpellUse('Усиление рунического оружия'); -- Если все руны КД и нету рунической силы то пытаемся использовать Усиление рунического оружия
end

function Attack3()
	SetTimeout('Attack3',0.5);
	A_Atack(3);
end
function Attack_3()
	if (IsBuf('Дух железного ястреба') == false) then SpellUse('Дух железного ястреба'); end -- Если не нажат дух ястреба то юзаем
	if (GetHeal('target') <= 20) then SpellUse('Убийственный выстрел'); end -- если у цели меньше 20% то юзаем убийтсвенный выстрел
	if (IsDeBuf('Укус змеи', 'target', true) == false and GetMana('player') >= 15) then SpellUse('Укус змеи'); end
	if (IsBuf('Огонь!')) then SpellUse('Прицельный выстрел'); end -- Если есть баф - Огонь! то юзаем прицельный выстрел
	if (GetHeal('pet') >= 0.01) then SpellUse('Ярость рыси'); end -- если пет не мертвый то юзаем ярость рыси
	if (GetMana('player') >= 45) then SpellUse('Выстрел химеры'); end -- Если концентрация больше или ровно 45% то юзаем выстрел химеры по кд
	SpellUse('Мощный выстрел'); -- По кд мощьный выстрел
	if ((IsBuf('Охотничий азарт') and GetMana('player') >= 10) or GetMana('player') >= 30) then SpellUse('Чародейский выстрел'); end -- если 30% концентрации или 10% и есть прок - чародейский выстрел
	SpellUse('Верный выстрел'); -- Если не чего выше не юзнулось - юзаем верный выстрел.
end



function Attack4()
	SetTimeout('Attack4',0.3);
	A_Atack(4);
end
function Attack_4()
	--UnitPower('player', 13)
	if (IsBuf('Облик Тьмы') == false) then SpellUse('Облик Тьмы'); end
	if (IsBuf('Внутренний огонь') == false) then SpellUse('Внутренний огонь'); end
	if (IsCasting()) then return; end
	if (IsDeBuf('Прикосновение вампира') == false) then SpellUse('Прикосновение вампира'); end
	if (IsDeBuf('Слово Тьмы: Боль') == false) then SpellUse('Слово Тьмы: Боль'); end
	if (IsDeBuf('Всепожирающая чума') ~= false) then SpellUse('Пытка разума'); end
	if (UnitPower('player', 13) == false or UnitPower('player', 13) < 3) then SpellUse('Взрыв разума'); end
	if (UnitPower('player', 13) ~= false and UnitPower('player', 13) == 3) then SpellUse('Всепожирающая чума'); end
	SpellUse('Пытка разума');
end
function SS()
	IsBuf('Костяной щит');
end



