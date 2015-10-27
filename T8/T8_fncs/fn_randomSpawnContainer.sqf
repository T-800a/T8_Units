private [ "_type", "_min", "_random", "_side" ];

_type = [_this, 0, "INFANTRY", [""]] call BIS_fnc_param;
_min = [_this, 1, 1, [0]] call BIS_fnc_param;
_random = [_this, 2, 0, [0]] call BIS_fnc_param;
_side = [_this, 3, east, [east]] call BIS_fnc_param;

_spawnContainer = [];

if (_type == "INFANTRY") then {
	_opforPool = ["O_G_Soldier_F","O_G_Soldier_lite_F","O_G_Soldier_SL_F","O_G_Soldier_TL_F","O_G_Soldier_AR_F","O_G_medic_F","O_G_engineer_F","O_G_Soldier_exp_F","O_G_Soldier_GL_F","O_G_Soldier_M_F","O_G_Soldier_LAT_F","O_G_Soldier_A_F","O_G_officer_F","O_Soldier_F","O_officer_F","O_Soldier_lite_F","O_Soldier_GL_F","O_Soldier_AR_F","O_Soldier_SL_F", "O_Soldier_TL_F","O_soldier_M_F","O_Soldier_LAT_F","O_medic_F","O_soldier_repair_F","O_soldier_exp_F","O_Soldier_A_F","O_Soldier_AT_F","O_Soldier_AA_F","O_engineer_F","O_Sharpshooter_F","O_HeavyGunner_F","O_G_Sharpshooter_F","O_recon_F","O_recon_M_F","O_recon_LAT_F","O_recon_medic_F","O_recon_exp_F","O_recon_JTAC_F", "O_recon_TL_F","O_Pathfinder_F","O_sniper_F","O_ghillie_lsh_F","O_ghillie_sard_F","O_ghillie_ard_F"];

	_blueforPool = ["B_Soldier_F","B_Soldier_02_f","B_Soldier_03_f","B_Soldier_04_f","B_Soldier_05_f","B_Soldier_lite_F","B_Soldier_GL_F","B_soldier_AR_F","B_Soldier_SL_F","B_Soldier_TL_F","B_soldier_M_F","B_soldier_LAT_F","B_medic_F","B_soldier_repair_F","B_soldier_exp_F","B_Soldier_A_F","B_soldier_AT_F","B_soldier_AA_F","B_engineer_F","B_officer_F","B_soldier_PG_F","B_recon_F","B_recon_LAT_F","B_recon_exp_F","B_recon_medic_F","B_recon_TL_F","B_recon_M_F","B_recon_JTAC_F","B_spotter_F","B_sniper_F","B_support_MG_F","B_support_GMG_F","B_support_Mort_F","B_support_AMG_F","B_support_AMort_F","B_ghillie_lsh_F","B_ghillie_sard_F","B_ghillie_ard_F","B_Sharpshooter_F","B_Recon_Sharpshooter_F","B_HeavyGunner_F","B_G_Sharpshooter_F"];

	_guerPool = ["I_G_Soldier_F","I_G_Soldier_lite_F","I_G_Soldier_SL_F","I_G_Soldier_TL_F","I_G_Soldier_AR_F","  	I_G_medic_F","I_G_engineer_F","I_G_Soldier_exp_F","I_G_Soldier_GL_F","I_G_Soldier_M_F","I_G_Soldier_LAT_F","I_G_Soldier_A_F","I_G_officer_F","I_Soldier_02_F","I_Soldier_03_F","I_Soldier_04_F","I_soldier_F","  	I_Soldier_lite_F","I_Soldier_A_F","I_Soldier_GL_F","I_Soldier_AR_F","I_Soldier_SL_F","I_Soldier_TL_F","I_Soldier_M_F","I_Soldier_LAT_F","I_Soldier_AT_F","I_Soldier_AA_F","I_medic_F","I_Soldier_repair_F","I_Soldier_exp_F","I_engineer_F","I_officer_F","I_Spotter_F","I_Sniper_F","I_Soldier_AAR_F","I_Soldier_AAT_F","I_Soldier_AAA_F","I_support_MG_F","I_support_GMG_F","I_support_Mort_F","I_support_AMG_F","I_support_AMort_F"," I_ghillie_lsh_F","I_ghillie_sard_F","I_ghillie_ard_F","I_G_Sharpshooter_F"];

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
};

_spawnContainer