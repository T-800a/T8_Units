params ["_opforPool", "_blueforPool", "_guerPool", "_min", "_random", "_side"];

private ["_spawnContainer", "_selectionPool"];

_spawnContainer = [];
_selectionPool = _opforPool;
switch (_side) do {
    case west: { _selectionPool = _blueforPool; };
    case resistance: { _selectionPool = _guerPool; };
};

for [{_i = 0},{_i < _min},{_i =_i+1}] do {
	_spawnContainer pushBack (_selectionPool call BIS_fnc_selectRandom);
};

if(_random != 0) then {
	_randomPick = random _random;
	for [{_i = 0},{_i < _randomPick},{_i =_i+1}] do {
		_spawnContainer pushBack (_selectionPool call BIS_fnc_selectRandom);
	};
};

_spawnContainer