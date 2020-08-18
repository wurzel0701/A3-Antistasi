////////////////////////////////////
//       NAMES AND FLAGS         ///
////////////////////////////////////
nameTeamPlayer = "ARVN";
SDKFlag = "uns_FlagCarrierSVN";
SDKFlagTexture = "uns_flags\flag_rvn_co.paa";
typePetros = "uns_men_ARVN_COM";

////////////////////////////////////
//             UNITS             ///
////////////////////////////////////
//First Entry is Guerilla, Second Entry is Para/Military
staticCrewTeamPlayer = "uns_men_ARVNci_S4";
SDKUnarmed = "uns_men_ARVN_CAS";
SDKSniper = ["uns_men_CIDG_MRK2","uns_men_ARVN_MRK"];
SDKATman = ["uns_men_CIDG_AT","uns_men_ARVN_AT"];
SDKMedic = ["uns_men_ARVNci_MED","uns_men_ARVN_MED"];
SDKMG = ["uns_men_ARVNci_HMG","uns_men_ARVN_HMG"];
SDKExp = ["uns_men_CIDG_SAP","uns_men_ARVN_SAP"];
SDKGL = ["uns_men_CIDG_GL","uns_men_ARVN_GL"];
SDKMil = ["uns_men_ARVNci_SCT","uns_men_ARVN_SCT"];
SDKSL = ["uns_men_ARVNci_PL","uns_men_ARVN_PL"];
SDKEng = ["uns_men_ARVNci_ENG","uns_men_ARVN_ENG"];

////////////////////////////////////
//            GROUPS             ///
////////////////////////////////////
groupsSDKmid = [SDKSL,SDKGL,SDKMG,SDKMil];
groupsSDKAT = [SDKSL,SDKMG,SDKATman,SDKATman,SDKATman];
groupsSDKSquad = [SDKSL,SDKGL,SDKMil,SDKMG,SDKMil,SDKATman,SDKMil,SDKMedic];
groupsSDKSquadEng = [SDKSL,SDKGL,SDKMil,SDKMG,SDKExp,SDKATman,SDKEng,SDKMedic];
groupsSDKSquadSupp = [SDKSL,SDKGL,SDKMil,SDKMG,SDKATman,SDKMedic,[staticCrewTeamPlayer,staticCrewTeamPlayer],[staticCrewTeamPlayer,staticCrewTeamPlayer]];
groupsSDKSniper = [SDKSniper,SDKSniper];
groupsSDKSentry = [SDKGL,SDKMil];

//Rebel Unit Tiers (for costs)
sdkTier1 = SDKMil + [staticCrewTeamPlayer] + SDKMG + SDKGL + SDKATman;
sdkTier2 = SDKMedic + SDKExp + SDKEng;
sdkTier3 = SDKSL + SDKSniper;
soldiersSDK = sdkTier1 + sdkTier2 + sdkTier3;

////////////////////////////////////
//           VEHICLES            ///
////////////////////////////////////
//Military Vehicles
vehSDKBike = "uns_m274";
vehSDKLightArmed = "uns_willys_2_m60_arvn";
vehSDKAT = "uns_willysm40";
vehSDKLightUnarmed = "uns_willys_2_arvn";
vehSDKTruck = "uns_nvatruck";
vehSDKPlane = "uns_A1H_CAS";
vehSDKBoat = "UNS_PATROL_BOAT_VC";
vehSDKRepair = "uns_zil157_repair";
vehSDKAA = "uns_nvatruck_zpu";

//Civilian Vehicles
civCar = "uns_willys";
civTruck = "uns_zil157";
civHeli = "not_supported";
civBoat = "UNS_skiff_C";

////////////////////////////////////
//        STATIC WEAPONS         ///
////////////////////////////////////
//Assembled Static Weapons
SDKMGStatic = "uns_mg42_low_VC";
staticATteamPlayer = "uns_Type36_57mm_VC";
staticAAteamPlayer = "uns_Type74_VC";
SDKMortar = "uns_m1941_82mm_mortarVC";
SDKMortarHEMag = "uns_8Rnd_82mmHE_M1941";
SDKMortarSmokeMag = "uns_8Rnd_82mmWP_M1941";

//Static Weapon Bags
MGStaticSDKB = "uns_MG42_VC_Bag";
ATStaticSDKB = "uns_Type36_VC_Bag";
AAStaticSDKB = "not_supported";
MortStaticSDKB = "uns_M1941_82mm_mortar_VC_Bag";
//Short Support
supportStaticSDKB = "uns_Tripod_Bag";
//Tall Support
supportStaticsSDKB2 = "uns_Tripod_Bag";
//Mortar Support
supportStaticsSDKB3 = "uns_Tripod_Bag";

////////////////////////////////////
//             ITEMS             ///
////////////////////////////////////
//Mines
ATMineMag = "uns_mine_AT_mag";
APERSMineMag = "uns_mine_IN_mag";

//Breaching explosives
//Breaching APCs needs one demo charge
breachingExplosivesAPC = [["uns_M118_mag_remote", 1]];
//Breaching tanks needs one satchel charge or two demo charges
breachingExplosivesTank = [["uns_mine_TM_mag", 1], ["uns_M118_mag_remote", 2]];

//Starting Unlocks
initialRebelEquipment append ["uns_38spec","uns_Ruger","uns_smle","uns_mac10"];
initialRebelEquipment append ["b_smle_1937"];
initialRebelEquipment append ["uns_38specmag","uns_Rugermag","uns_smlemag_T","uns_mac10mag","uns_molotov_mag","uns_m18white"];
initialRebelEquipment append ["UNS_CIV_R1"];
initialRebelEquipment append ["UNS_M1956_LRRP1","UNS_M1956_P1"];
initialRebelEquipment append ["Binocular","uns_rkg3gren"];
//TFAR Unlocks
if (hasTFAR) then {initialRebelEquipment append ["tf_microdagr","UNS_ItemRadio_PRC_90_TFAR"]};
if (hasTFAR && startWithLongRangeRadio) then {initialRebelEquipment pushBack "UNS_USMC_RTO"};
