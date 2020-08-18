////////////////////////////////////
//       NAMES AND FLAGS         ///
////////////////////////////////////
//Name Used for notifications
nameOccupants = "USAF";

//Police Faction
factionGEN = "UNSUNG_AUS";
//SF Faction
factionMaleOccupants = "";
//Miltia Faction
if (gameMode != 4) then {factionFIA = "UNSUNG_ROK"};

//Flag Images
NATOFlag = "Flag_US_F";
NATOFlagTexture = "a3\data_f\flags\flag_us_co.paa";
flagNATOmrk = "Faction_UNS_USA";
if (isServer) then {"NATO_carrier" setMarkerText "USS Oklahoma City"};

//Loot Crate
NATOAmmobox = "B_supplyCrate_F";

////////////////////////////////////
//   PVP LOADOUTS AND VEHICLES   ///
////////////////////////////////////
//PvP Loadouts
NATOPlayerLoadouts = [
	//Team Leader
	/*["Templates\UNSUNG\Loadouts\"] call A3A_fnc_getLoadout,
	//Medic
	["Templates\UNSUNG\Loadouts\"] call A3A_fnc_getLoadout,
	//Autorifleman
	["Templates\UNSUNG\Loadouts\"] call A3A_fnc_getLoadout,
	//Marksman
	["Templates\UNSUNG\Loadouts\"] call A3A_fnc_getLoadout,
	//Anti-tank Scout
	["Templates\UNSUNG\Loadouts\"] call A3A_fnc_getLoadout,
	//AT2
	["Templates\UNSUNG\Loadouts\"] call A3A_fnc_getLoadout*/
	"uns_men_US_6SFG_COM","uns_men_US_6SFG_MED","uns_men_US_6SFG_HMG","uns_men_US_6SFG_MRK4","uns_men_US_6SFG_AT","uns_men_US_6SFG_AT"
];

//PVP Player Vehicles
vehNATOPVP = ["uns_willys_2_usmc","uns_willys_2_m60"];

////////////////////////////////////
//             UNITS             ///
////////////////////////////////////
//Military Units
NATOGrunt = "uns_US_25ID_RF5";
NATOOfficer = "uns_US_25ID_COM";
NATOOfficer2 = "uns_US_25ID_PL";
NATOBodyG = "uns_US_25ID_RTO";
NATOCrew = "uns_US_2MI_DRV";
NATOUnarmed = "uns_US_25ID_CAS";
NATOMarksman = "uns_US_25ID_MRK3";
staticCrewOccupants = "uns_US_25ID_STY";
NATOPilot = "uns_pilot17";

//Militia Units
if (gameMode != 4) then
	{
	FIARifleman = "uns_men_ROK_C65_RF6";
	FIAMarksman = "uns_men_ROK_C65_MRK2";
	};

//Police Units
policeOfficer = "uns_men_RAR_65_SCT";
policeGrunt = "uns_men_RAR_65_SCT2";

////////////////////////////////////
//            GROUPS             ///
////////////////////////////////////
//Military Groups
//Teams
groupsNATOSentry = ["uns_US_25ID_STY2","uns_US_25ID_STY"];
groupsNATOSniper = ["uns_US_25ID_MRK","uns_US_25ID_MRK2"];
groupsNATOsmall = [groupsNATOSentry,groupsNATOSniper,["uns_US_25ID_STY3","uns_US_25ID_STY"]];
//Fireteams
groupsNATOAA = ["uns_US_25ID_MGAASG","uns_US_25ID_MGAASG","uns_US_25ID_TRI","uns_US_25ID_TRI"];
groupsNATOAT = ["uns_US_25ID_STY2","uns_US_25ID_AT","uns_US_25ID_AT","uns_US_25ID_AT"];
groupsNATOmid = [["uns_US_25ID_STY2","uns_US_25ID_STY","uns_US_25ID_STY3","uns_US_25ID_SCT"],groupsNATOAA,groupsNATOAT];
//Squads
NATOSquad = ["uns_US_25ID_PL","uns_US_25ID_RTO","uns_US_25ID_RF5","uns_US_25ID_DEM","uns_US_25ID_SL","uns_US_25ID_HMG","uns_US_25ID_AHMG","uns_US_25ID_MED"];
NATOSpecOp = ["uns_men_US_6SFG_PL","uns_men_US_6SFG_RTO","uns_men_US_6SFG_GL4","uns_men_US_6SFG_SAP","uns_men_US_6SFG_SL","uns_men_US_6SFG_HMG2","uns_men_US_6SFG_DEM","uns_men_US_6SFG_MED"];
groupsNATOSquad =
	[
	NATOSquad,
	["uns_US_25ID_PL","uns_US_25ID_RTO","uns_US_25ID_RF5","uns_US_25ID_ENG","uns_US_25ID_SL","uns_US_25ID_GL","uns_US_25ID_MRK2","uns_US_25ID_MED"],
	["uns_US_25ID_PL","uns_US_25ID_RTO","uns_US_25ID_HMG","uns_US_25ID_AHMG","uns_US_25ID_SL","uns_US_25ID_HMG","uns_US_25ID_AHMG","uns_US_25ID_MED"],
	["uns_US_25ID_PL","uns_US_25ID_RTO","uns_US_25ID_RF5","uns_US_25ID_GL","uns_US_25ID_SL","uns_US_25ID_AT","uns_US_25ID_SAP","uns_US_25ID_MED"]
	];

//Militia Groups
if (gameMode != 4) then
	{
	//Teams
	groupsFIASmall =
		[
		["uns_men_ROK_C65_STY2","uns_men_ROK_C65_STY"],
		["uns_men_ROK_C65_MRK","uns_men_ROK_C65_MRK2"],
		["uns_men_ROK_C65_STY2","uns_men_ROK_C65_SCT"]
		];
	//Fireteams
	groupsFIAMid =
		[
		["uns_men_ROK_C65_MGAASG","uns_men_ROK_C65_TRI","uns_men_ROK_C65_MTSG","uns_men_ROK_C65_TRI"],
		["uns_men_ROK_C65_STY2","uns_men_ROK_C65_AT","uns_men_ROK_C65_AT","uns_men_ROK_C65_AT"],
		["uns_men_ROK_C65_STY2","uns_men_ROK_C65_SCT","uns_men_ROK_C65_STY3","uns_men_ROK_C65_SAP"]
		];
	//Squads
	FIASquad = ["uns_men_ROK_C65_PL","uns_men_ROK_C65_RTO","uns_men_ROK_C65_GL","uns_men_ROK_C65_RF6","uns_men_ROK_C65_SL","uns_men_ROK_C65_AR","uns_men_ROK_C65_AT","uns_men_ROK_C65_MED"];
	groupsFIASquad =
		[
		FIASquad,
		["uns_men_ROK_C65_PL","uns_men_ROK_C65_RTO","uns_men_ROK_C65_MRK2","uns_men_ROK_C65_ENG","uns_men_ROK_C65_SL","uns_men_ROK_C65_DEM","uns_men_ROK_C65_SAP","uns_men_ROK_C65_MED"]
		];
	};

//Police Groups
//Teams
groupsNATOGen = [policeOfficer,policeGrunt];

////////////////////////////////////
//           VEHICLES            ///
////////////////////////////////////
//Military Vehicles
//Lite
vehNATOBike = "uns_m274";
vehNATOLightArmed = ["uns_willysmg","uns_willysmg50","uns_willys_2_m1919","uns_willysm40","uns_m37b1_m1919"];
vehNATOLightUnarmed = ["uns_willys_2"];
vehNATOTrucks = ["uns_m37b1","uns_M35A2_Open","uns_M35A2"];
vehNATOCargoTrucks = ["uns_M35A2_Open","uns_M35A2"];
vehNATOAmmoTruck = "uns_M35A2_ammo";
vehNATORepairTruck = "uns_M35A2_repair";
vehNATOLight = vehNATOLightArmed + vehNATOLightUnarmed;
//Armored
vehNATOAPC = ["uns_M113_transport","uns_M113_M60","uns_M113_30cal","uns_M113_M2","uns_M113_M134","uns_M113_XM182","uns_M113A1_M60","uns_M113A1_M2","uns_M113A1_M134","uns_M113A1_XM182","uns_M113A1_M40","uns_M132"];
vehNATOTank = "uns_m48a3";
vehNATOAA = "uns_m163";
vehNATOAttack = vehNATOAPC + [vehNATOTank];
//Boats
vehNATOBoat = "uns_PBR_M10";
vehNATORBoat = "UNS_Zodiac_W";
vehNATOBoats = [vehNATOBoat,vehNATORBoat,"uns_pbr","uns_pbr_mk18"];
//Planes
vehNATOPlane = "uns_A6_Intruder_CAS";
vehNATOPlaneAA = "uns_F4J_CAP";
vehNATOTransportPlanes = ["uns_c1a6","uns_c1a","uns_c1a7","uns_c1a3","uns_c1a5","uns_c1a4","uns_c1a2"];
//Heli
vehNATOPatrolHeli = "uns_H13_transport_Army";
vehNATOTransportHelis = [vehNATOPatrolHeli,"uns_ch34_army","uns_ch34_army_M60","uns_UH1D_m60","uns_UH1D_m60_light","uns_UH1H_m60","uns_UH1H_m60_light","uns_h21c","uns_h21c_mg","uns_ch47_m60_army"];
vehNATOAttackHelis = ["UNS_UH1B_TOW","uns_UH1C_M21_M158","uns_UH1C_M21_M158_M134","uns_UH1C_M21_M200","UNS_UH1C_M3_ARA","UNS_UH1C_M3_ARA_AP","UNS_UH1C_M3_ARA_AT","uns_UH1C_M6_M158","uns_UH1C_M6_M200","uns_UH1C_M6_M200_M134","uns_UH1C_M6_M200_1AC","uns_H13_gunship_Army","uns_oh6_m27","uns_oh6_m27r","uns_oh6_xm8","UNS_AH1G","UNS_AH1G_M158","UNS_AH1G_FFAR","UNS_AH1G_M195","UNS_AH1G_M200","UNS_AH1G_SUU11","uns_ach47_m200","uns_ach47_m134"];
//UAV
vehNATOUAV = "UNS_skymaster_OBS";
vehNATOUAVSmall = "not_supported";
//Artillery
vehNATOMRLS = "uns_m107sp";
vehNATOMRLSMags = "uns_30Rnd_175mmWP";
//Combined Arrays
vehNATONormal = vehNATOLight + vehNATOTrucks + [vehNATOAmmoTruck, vehNATORepairTruck,"uns_M577_amb","uns_M35A2_fueltanker","uns_M35A2_fuel","uns_M113_ENG"];
vehNATOAir = vehNATOTransportHelis + vehNATOAttackHelis + [vehNATOPlane,vehNATOPlaneAA] + vehNATOTransportPlanes;

//Militia Vehicles
if (gameMode != 4) then
	{
	vehFIAArmedCar = "uns_m274_m60";
	vehFIATruck = "uns_m37b1";
	vehFIACar = "uns_willys";
	};

//Police Vehicles
vehPoliceCar = "uns_willys_2_usmp";

////////////////////////////////////
//        STATIC WEAPONS         ///
////////////////////////////////////
//Assembled Statics
NATOMG = "uns_m2_high";
staticATOccupants = "uns_M40_106mm_US";
staticAAOccupants = "Uns_M55_Quad";
NATOMortar = "uns_M30_107mm_mortar";

//Static Weapon Bags
MGStaticNATOB = "uns_m2_high_US_Bag";
ATStaticNATOB = "not_supported";
AAStaticNATOB = "not_supported";
MortStaticNATOB = "uns_M30_107mm_mortar_US_Bag";
//Short Support
supportStaticNATOB = "uns_Tripod_Bag";
//Tall Support
supportStaticNATOB2 = "uns_Tripod_Bag";
//Mortar Support
supportStaticNATOB3 = "uns_Tripod_Bag";
