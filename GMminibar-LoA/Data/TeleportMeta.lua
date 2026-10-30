GMMPandaria548 = GMMPandaria548 or {}
local AAM = GMMPandaria548

-- Display labels are deliberately separate from the canonical game_tele name.
-- The key in this table is the exact server-side `game_tele.name` used by .tele.
AAM.TeleportMeta = {
  Stormwind={koKR="스톰윈드",zhCN="暴风城",zhTW="暴風城",ruRU="Штормград",group="capitals",popular=true,aliases={"stormwind city","스톰","얼라이언스 수도"}},
  Orgrimmar={koKR="오그리마",zhCN="奥格瑞玛",zhTW="奧格瑪",ruRU="Оргриммар",group="capitals",popular=true,aliases={"org","오그","호드 수도"}},
  Ironforge={koKR="아이언포지",zhCN="铁炉堡",zhTW="鐵爐堡",ruRU="Стальгорн",group="capitals",popular=true,aliases={"아이언 포지"}},
  Darnassus={koKR="다르나서스",zhCN="达纳苏斯",zhTW="達納蘇斯",ruRU="Дарнас",group="capitals",popular=true},
  TheExodar={koKR="엑소다르",zhCN="埃索达",zhTW="艾克索達",ruRU="Экзодар",group="capitals",popular=true,aliases={"exodar"}},
  ThunderBluff={koKR="썬더 블러프",zhCN="雷霆崖",zhTW="雷霆崖",ruRU="Громовой Утес",group="capitals",popular=true,aliases={"썬더블러프","천둥절벽"}},
  Undercity={koKR="언더시티",zhCN="幽暗城",zhTW="幽暗城",ruRU="Подгород",group="capitals",popular=true,aliases={"언더 시티"}},
  SilvermoonCity={koKR="실버문",zhCN="银月城",zhTW="銀月城",ruRU="Луносвет",group="capitals",popular=true,aliases={"실버문 시티","silvermoon"}},
  Shattrath={koKR="샤트라스",zhCN="沙塔斯",zhTW="撒塔斯",ruRU="Шаттрат",group="capitals",popular=true,aliases={"샤트라스 시티"}},
  Dalaran={koKR="달라란",zhCN="达拉然",zhTW="達拉然",ruRU="Даларан",group="capitals",popular=true},

  ShrineofSevenStars={koKR="일곱 별의 제단",zhCN="七星殿",zhTW="七星廟",ruRU="Святилище Семи Звезд",group="pandaria",popular=true,aliases={"일곱별","일곱 별","seven stars","얼라이언스 판다리아 수도"}},
  ShrineofTwoMoons={koKR="두 달의 제단",zhCN="双月殿",zhTW="雙月廟",ruRU="Святилище Двух Лун",group="pandaria",popular=true,aliases={"두달","두 달","two moons","호드 판다리아 수도"}},
  TheJadeForest={koKR="비취 숲",zhCN="翡翠林",zhTW="翠玉林",ruRU="Нефритовый лес",group="pandaria",popular=true,aliases={"비취숲","jade forest"}},
  ValleyoftheFourWinds={koKR="네 바람의 계곡",zhCN="四风谷",zhTW="四風峽",ruRU="Долина Четырех Ветров",group="pandaria",popular=true,aliases={"네바람의계곡","네바람","four winds"}},
  KrasarangWilds={koKR="크라사랑 밀림",zhCN="卡桑琅丛林",zhTW="喀撒朗蠻荒",ruRU="Красарангские джунгли",group="pandaria",popular=true,aliases={"크라사랑","krasarang"}},
  KunLaiSummit={koKR="쿤라이 봉우리",zhCN="昆莱山",zhTW="崑萊峰",ruRU="Вершина Кунь-Лай",group="pandaria",popular=true,aliases={"쿤라이","kun lai","kun-lai"}},
  TownlongSteppes={koKR="탕랑 평원",zhCN="螳螂高原",zhTW="螳螂荒原",ruRU="Танлунские степи",group="pandaria",popular=true,aliases={"탕랑","townlong"}},
  DreadWastes={koKR="공포의 황무지",zhCN="恐惧废土",zhTW="悚然荒野",ruRU="Жуткие пустоши",group="pandaria",popular=true,aliases={"공포 황무지","dread wastes"}},
  ValeofEternalBlossoms={koKR="영원꽃 골짜기",zhCN="锦绣谷",zhTW="恆春谷",ruRU="Вечноцветущий дол",group="pandaria",popular=true,aliases={"영원꽃골짜기","영꽃","vale of eternal blossoms"}},
  TimelessIsle={koKR="영원의 섬",zhCN="永恒岛",zhTW="永恆之島",ruRU="Вневременный остров",group="pandaria",popular=true,aliases={"영원의섬","영섬","timeless isle"}},
  IsleofThunder={koKR="천둥의 섬",zhCN="雷神岛",zhTW="雷王島",ruRU="Остров Грома",group="pandaria",popular=true,aliases={"천둥섬","천둥의섬","isle of thunder"}},
  ThroneofThunder={koKR="천둥의 왕좌",zhCN="雷电王座",zhTW="雷霆王座",ruRU="Престол Гроз",group="instances",popular=true,aliases={"천둥왕좌","천둥의왕좌","throne of thunder"}},
  SiegeofOrgrimmar={koKR="오그리마 공성전",zhCN="决战奥格瑞玛",zhTW="圍攻奧格瑪",ruRU="Осада Оргриммара",group="instances",popular=true,aliases={"오공","공성전","siege of orgrimmar"}},
  TempleoftheJadeSerpent={koKR="옥룡사",zhCN="青龙寺",zhTW="玉蛟寺",ruRU="Храм Нефритовой Змеи",group="instances",popular=true,aliases={"옥룡 사원","비취뱀 사원","jade serpent"}},
  DarkHeartOfPandaria={koKR="판다리아의 검은 심장",zhCN="潘达利亚的黑暗之心",zhTW="潘達利亞之暗",ruRU="Темное сердце Пандарии",group="instances",aliases={"검은 심장","dark heart of pandaria"}},
  AssaultOnZanvess={koKR="잔베스 강습",zhCN="突袭扎尼维斯",zhTW="突襲贊斐斯",ruRU="Штурм Зан'весса",group="instances",aliases={"잔베스","zanvess"}},

  BootyBay={koKR="무법항",group="eastern",popular=true,aliases={"부티베이"}},
  Goldshire={koKR="골드샤이어",group="eastern",aliases={"골드 샤이어"}},
  Lakeshire={koKR="레이크샤이어",group="eastern"},
  Darkshire={koKR="다크샤이어",group="eastern"},
  TheCrossroads={koKR="십자로",group="kalimdor",aliases={"크로스로드"}},
  Ratchet={koKR="톱니항",group="kalimdor",aliases={"라쳇"}},
  Gadgetzan={koKR="가젯잔",group="kalimdor",popular=true},
  Everlook={koKR="눈망루 마을",group="kalimdor",aliases={"에버룩"}},
  Area52={koKR="52번 구역",group="outland",popular=true,aliases={"지역 52","area 52"}},
  HonorHold={koKR="명예의 요새",group="outland",aliases={"아너홀드"}},
  Thrallmar={koKR="스랄마",group="outland"},
  WarsongHold={koKR="전쟁노래 요새",group="northrend"},
  ValianceKeep={koKR="용맹의 성채",group="northrend"},
  ArgentTournament={koKR="은빛십자군 마상시합장",group="northrend",aliases={"은빛십자군","마상시합"}},
}

AAM.TeleportGroupOrder = {
  "popular", "capitals", "pandaria", "instances", "eastern", "kalimdor", "outland", "northrend", "other", "all"
}

AAM.TeleportGroupNames = {
  enUS={popular="Popular",capitals="Capitals",pandaria="Pandaria",instances="Dungeons / Raids",eastern="Eastern Kingdoms",kalimdor="Kalimdor",outland="Outland",northrend="Northrend",other="Other",all="All"},
  koKR={popular="자주 사용",capitals="대도시",pandaria="판다리아",instances="던전 / 공격대",eastern="동부왕국",kalimdor="칼림도어",outland="아웃랜드",northrend="노스렌드",other="기타",all="전체"},
  zhCN={popular="常用",capitals="主城",pandaria="潘达利亚",instances="地下城/团队",eastern="东部王国",kalimdor="卡利姆多",outland="外域",northrend="诺森德",other="其他",all="全部"},
  zhTW={popular="常用",capitals="主城",pandaria="潘達利亞",instances="地城/團隊",eastern="東部王國",kalimdor="卡林多",outland="外域",northrend="北裂境",other="其他",all="全部"},
  ruRU={popular="Частые",capitals="Столицы",pandaria="Пандария",instances="Подземелья / рейды",eastern="Восточные королевства",kalimdor="Калимдор",outland="Запределье",northrend="Нордскол",other="Другое",all="Все"},
}

-- Stable first-page ordering for the lists people actually use most.  This is
-- display ordering only; execution still sends the exact Generated game_tele
-- canonical name stored in row[2].
AAM.TeleportPriority = {
  Stormwind=1, Orgrimmar=2, Ironforge=3, Undercity=4, Darnassus=5, ThunderBluff=6, SilvermoonCity=7, TheExodar=8, Shattrath=9, Dalaran=10,
  ShrineofSevenStars=20, ShrineofTwoMoons=21, TheJadeForest=22, ValleyoftheFourWinds=23, KrasarangWilds=24, KunLaiSummit=25, TownlongSteppes=26, DreadWastes=27,
  ValeofEternalBlossoms=28, TimelessIsle=29, IsleofThunder=30, ThroneofThunder=31, SiegeofOrgrimmar=32, TempleoftheJadeSerpent=33,
  BootyBay=40, TheCrossroads=41, Ratchet=42, Gadgetzan=43, Area52=44,
}
