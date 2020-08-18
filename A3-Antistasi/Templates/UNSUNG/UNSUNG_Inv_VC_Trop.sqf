////////////////////////////////////
//       NAMES AND FLAGS         ///
////////////////////////////////////
//Name Used for notifications
nameInvaders = "VC";

//SF Faction
factionMaleInvaders = "UNSUNG_E";
//Miltia Faction
if (gameMode == 4) then {factionFIA = ""};

//Flag Images
CSATFlag = "pook_siteFlag_NVA";
CSATFlagTexture = "pook_sam\structures\flags\nva_flag.paa";
flagCSATmrk = "Faction_UNS_VC";
if (isServer) then {"CSAT_carrier" setMarkerText "VC Carrier?!? (Don't ask...)"};

//Loot Crate
CSATAmmoBox = "O_supplyCrate_F";

////////////////////////////////////
//   PVP LOADOUTS AND VEHICLES   ///
////////////////////////////////////
//PvP Loadouts
CSATPlayerLoadouts = [
	//Team Leader
	/*["Templates\UNSUNG\Loadouts\UNSUNG_opfor_teamLeader_trop"] call A3A_fnc_getLoadout,
	//Medic
	["Templates\UNSUNG\Loadouts\UNSUNG_opfor_medic_trop"] call A3A_fnc_getLoadout,
	//Autorifleman
	["Templates\UNSUNG\Loadouts\UNSUNG_opfor_machineGunner_trop"] call A3A_fnc_getLoadout,
	//Marksman
	["Templates\UNSUNG\Loadouts\UNSUNG_opfor_marksman_trop"] call A3A_fnc_getLoadout,
	//Anti-tank Scout
	["Templates\UNSUNG\Loadouts\UNSUNG_opfor_AT_trop"] call A3A_fnc_getLoadout,
	//AT2
	["Templates\UNSUNG\Loadouts\UNSUNG_opfor_AT2_trop"] call A3A_fnc_getLoadout*/
	["uns_men_NVA_68_nco","uns_men_NVA_68_MED","uns_men_NVA_68_LMG","uns_men_NVA_68_MRK","uns_men_NVA_68_AT","uns_men_NVA_68_AT2"]
];

//PVP Player Vehicles
vehCSATPVP = ["uns_Type55","uns_Type55_MG","uns_Type55_LMG"];

////////////////////////////////////
//             UNITS             ///
////////////////////////////////////
//Military Units
CSATGrunt = "uns_men_VC_mainforce_68_RF3";
CSATOfficer = "uns_men_NVA_65_COM";
CSATBodyG = "uns_men_NVA_65_RTO";
CSATCrew = "uns_men_NVA_crew_driver";
CSATMarksman = "uns_men_VC_mainforce_MRK";
staticCrewInvaders = "uns_men_VC_mainforce_RF4";
CSATPilot = "uns_nvaf_pilot2";

//Militia Units
if (gameMode == 4) then
	{
	FIARifleman = "uns_men_VC_local_RF2";
	FIAMarksman = "uns_men_VC_local_MRK";
	};

////////////////////////////////////
//            GROUPS             ///
////////////////////////////////////
//Military Groups
//Teams
groupsCSATSentry = ["uns_men_VC_regional_Ra1","uns_men_VC_regional_Ra2"];
groupsCSATSniper = ["uns_men_VC_regional_MRK2","uns_men_VC_regional_MRK"];
groupsCSATsmall = [groupsCSATSentry,groupsCSATSniper];
//Fireteams
groupsCSATAA = ["uns_men_NVA_65_nco","uns_men_NVA_65_AA","uns_men_NVA_65_RF1","uns_men_NVA_65_RF3"];
groupsCSATAT = ["uns_men_VC_regional_nco","uns_men_VC_regional_AT2","uns_men_VC_regional_AT","uns_men_VC_regional_RF6"];
groupsCSATmid = [["uns_men_VC_regional_nco","uns_men_VC_regional_HMG","uns_men_VC_regional_SAP","uns_men_VC_regional_AS6"],groupsCSATAA,groupsCSATAT];
//Squads
CSATSquad = ["uns_men_VC_mainforce_off","uns_men_VC_mainforce_RTO","uns_men_VC_mainforce_LMG","uns_men_VC_mainforce_HMG","uns_men_VC_mainforce_nco","uns_men_VC_mainforce_MRK","uns_men_VC_mainforce_SAP","uns_men_VC_mainforce_MED"];
CSATSpecOp = ["uns_men_NVA_daccong_cov1","uns_men_NVA_daccong_cov6","uns_men_NVA_daccong_cov5","uns_men_NVA_daccong_cov2","uns_men_NVA_daccong_cov1","uns_men_NVA_daccong_cov7","uns_men_NVA_daccong_cov4","uns_men_NVA_daccong_cov3"];
groupsCSATSquad =
	[
	CSATSquad,
	["uns_men_VC_mainforce_off","uns_men_VC_mainforce_RTO","uns_men_VC_mainforce_AT2","uns_men_VC_mainforce_AT","uns_men_VC_mainforce_nco","uns_men_VC_mainforce_MRK","uns_men_VC_mainforce_SAP","uns_men_VC_mainforce_MED"],
	["uns_men_VC_mainforce_Roff","uns_men_VC_mainforce_RTO","uns_men_VC_mainforce_Rmg","uns_men_VC_mainforce_Ra1","uns_men_VC_mainforce_nco","uns_men_VC_mainforce_Rmrk","uns_men_VC_mainforce_Ra2","uns_men_VC_mainforce_Rmed"],
	["uns_men_VC_mainforce_off","uns_men_VC_mainforce_RTO","uns_men_VC_mainforce_AS4","uns_men_VC_mainforce_AS2","uns_men_VC_mainforce_nco","uns_men_VC_mainforce_AS3","uns_men_VC_mainforce_AS5","uns_men_VC_mainforce_MED"],
	["uns_men_VC_mainforce_off","uns_men_VC_mainforce_RTO","uns_men_VC_mainforce_RF2","uns_men_VC_mainforce_RF3","uns_men_VC_mainforce_nco","uns_men_VC_mainforce_RF4","uns_men_VC_mainforce_RF1","uns_men_VC_mainforce_MED"]
	];

//Militia Groups
if (gameMode == 4) then
	{
	//Teams
	groupsFIASmall =
		[
		["uns_men_VC_local_RF2","uns_men_VC_local_RF7"],
		["uns_men_VC_local_MRK2","uns_men_VC_local_MRK"]
		];
	//Fireteams
	groupsFIAMid =
		[
		["uns_men_VC_local_nco","uns_men_VC_local_LMG","uns_men_VC_local_RF4","uns_men_VC_local_RF3"],
		["uns_men_VC_local_nco","uns_men_VC_local_LMG","uns_men_VC_local_RF5","uns_men_VC_local_RF3"],
		["uns_men_VC_local_nco","uns_men_VC_local_LMG","uns_men_VC_local_RF1","uns_men_VC_local_RF3"],
		["uns_men_VC_local_nco","uns_men_VC_local_LMG","uns_men_VC_local_RF2","uns_men_VC_local_SAP"]
		];
	//Squads
	FIASquad = ["uns_men_VC_local_off","uns_men_VC_local_RF7","uns_men_VC_local_LMG","uns_men_VC_local_MRK","uns_men_VC_local_nco","uns_men_VC_local_RF1","uns_men_VC_local_SAP","uns_men_VC_local_MED"];
	groupsFIASquad =
		[
		FIASquad,
		["uns_men_VC_local_off","uns_men_VC_local_AS6","uns_men_VC_local_AS2","uns_men_VC_local_AS4","uns_men_VC_local_nco","uns_men_VC_local_AS7","uns_men_VC_local_AS8","uns_men_VC_local_MED"]
		];
	};

////////////////////////////////////
//           VEHICLES            ///
////////////////////////////////////
//Military Vehicles
//Lite
vehCSATBike = "O_Quadbike_01_F";
vehCSATLightArmed = ["uns_Type55_LMG","uns_Type55_MG","uns_Type55_twinMG","uns_Type55_patrol","uns_Type55_RR57","uns_Type55_RR73","uns_Type55_M40"];
vehCSATLightUnarmed = ["uns_Type55"];
vehCSATTrucks = ["uns_nvatruck","uns_nvatruck_camo","uns_nvatruck_open","uns_nvatruck_mg"];
vehCSATAmmoTruck = "uns_nvatruck_reammo";
vehCSATRepairTruck = "uns_nvatruck_repair";
vehCSATLight = vehCSATLightArmed + vehCSATLightUnarmed;
//Armored
vehCSATAPC = ["uns_BTR152_DSHK","uns_Type63_mg"];
vehCSATTank = "uns_ot34_85_nva";
vehCSATAA = "pook_ZSU57_NVA";
vehCSATAttack = vehCSATAPC + [vehCSATTank];
//Boats
vehCSATBoat = "UNS_ASSAULT_BOAT_VC";
vehCSATRBoat = "UNS_VC_Sampan_Transport";
vehCSATBoats = [vehCSATBoat,vehCSATRBoat];
//Planes
vehCSATPlane = "uns_an2_bmb";
vehCSATPlaneAA = "uns_Mig21_CAP";
vehCSATTransportPlanes = ["uns_an2_transport"];
//Heli
vehCSATPatrolHeli = "uns_Mi8T_VPAF";
vehCSATTransportHelis = ["uns_Mi8TV_VPAF_MG",vehCSATPatrolHeli];
vehCSATAttackHelis = ["uns_an2_cas"];
//UAV
vehCSATUAV = "not_supported";
vehCSATUAVSmall = "not_supported";
//Artillery
vehCSATMRLS = "Uns_D20_artillery";
vehCSATMRLSMags = "uns_30Rnd_155mmWP";
//Combined Arrays
vehCSATNormal = vehCSATLight + vehCSATTrucks + [vehCSATAmmoTruck, vehCSATRepairTruck, "uns_nvatruck_refuel","uns_Type63_amb"];
vehCSATAir = vehCSATTransportHelis + vehCSATAttackHelis + [vehCSATPlane,vehCSATPlaneAA] + vehCSATTransportPlanes;

//Militia Vehicles
if (gameMode == 4) then
	{
	vehFIAArmedCar = "uns_nvatruck_mg";
	vehFIATruck = "uns_nvatruck";
	vehFIACar = "uns_Type55";
	};

////////////////////////////////////
//        STATIC WEAPONS         ///
////////////////////////////////////
//Assembled Statics
CSATMG = "uns_dshk_twin_VC";
staticATInvaders = "uns_Type36_57mm_VC";
staticAAInvaders = "uns_ZPU4_VC";
CSATMortar = "uns_m1941_82mm_mortarVC";

//Static Weapon Bags
MGStaticCSATB = "Uns_Dshk_High_VC_Bag";
ATStaticCSATB = "uns_Type36_VC_Bag";
AAStaticCSATB = "not_supported";
MortStaticCSATB = "uns_M1941_82mm_mortar_VC_Bag";
//Short Support
supportStaticCSATB = "uns_Tripod_Bag";
//Tall Support
supportStaticCSATB2 = "uns_Tripod_Bag";
//Mortar Support
supportStaticCSATB3 = "uns_Tripod_Bag";
