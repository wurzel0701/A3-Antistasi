jnl_vehicleHardpoints = [
//4x4s
//Offroad
  ["\A3\soft_f\Offroad_01\Offroad_01_unarmed_F", [
    //type, location				locked seats
    [0,		[0,-1.7,-0.72],		[1,2,3,4]],		//weapon node
    [1,		[0,-1.7,-0.72],		[1,2,3,4]]		//cargo node
  ]],

//Van Cargo
  ["\a3\Soft_F_Orange\Van_02\Van_02_vehicle_F.p3d", [
    [1,		[0,0,-1],		[1,2,3,4,5,6,7]],
    [1,		[0,-2,-1],	[8,9]]
  ]],

//Van Transport
  ["\a3\Soft_F_Orange\Van_02\Van_02_transport_F.p3d", [
    [1,		[0,-1.7,-1],		[9,10]]
  ]],

//Small Truck
  ["\A3\soft_f_gamma\van_01\Van_01_transport_F.p3d", [
    [0,		[0,-1.6,-0.63],			[2,3,4,5,6,7,8,9]],
    [1,		[0,-1.06,-0.63],			[2,3,4,5]],
    [1,		[0,-2.61,-0.63],			[6,7,8,9,10,11]]
  ]],

//6x6s
//Zamak Open
  ["\A3\soft_f_beta\Truck_02\Truck_02_transport_F", [
    [0,		[0,-1.31,-0.81],	[2,3,4,5,6,7,8,9,10,11,12,13]],
    [1,		[0,0,-0.81],					[2,3,4,5,6,7,8]],
    [1,		[0,-2.1,-0.81],					[9,10,11,12,13]]
  ]],

//Zamak Covered
	["\A3\soft_f_beta\Truck_02\Truck_02_covered_F.p3d", [
	  [1,		[0,0,-0.81],					[2,3,4,5,6,7,8]],
		[1,		[0,-2.1,-0.81],					[9,10,11,12,13]]
	]],

//CSAT Tempest open
	["\A3\Soft_F_EPC\Truck_03\Truck_03_transport_F.p3d",[
		[1,	[0.0,-0.9,-0.4],		[1,7,6,9]],
		[1,	[0.0,-2.5,-0.4],		[2,3,8,12]],
		[1,	[0.0,-4.1,-0.4],			[4,5,11,10]]
	]],

//CSAT Tempest closed
	["\A3\Soft_F_EPC\Truck_03\Truck_03_covered_F.p3d",[
    [1,	[0.0,-0.9,-0.4],		[1,7,6,9]],
    [1,	[0.0,-2.5,-0.4],		[2,3,8,12]],
    [1,	[0.0,-4.1,-0.4],		[4,5,11,10]]
	]],

//8x8s
//HEMTT open
  ["\A3\soft_f_beta\Truck_01\Truck_01_transport_F.p3d",[
    [1,[0,-0.222656,-0.5],[3,4,10,11,2]],
    [1,[0,-2.16602,-0.5],[1,16,8,9]],
    [1,[0,-4.11816,-0.5],[5,6,12,13,15,7]]
  ]],

//HEMMT closed
  ["\A3\soft_f_beta\Truck_01\Truck_01_covered_F.p3d",[
    [1,[0,-0.224609,-0.5],[1,16,8,9,2]],
    [1,[0,-2.16016,-0.5],[3,4,10,11]],
    [1,[0,-4.10547,-0.5],[5,6,12,13,15]]
  ]],

//Vanilla HEMTT Flatbed
  ["a3\Soft_F_Gamma\Truck_01\Truck_01_flatbed_F.p3d",[
      [0,[0.0,-0.29,-0.79],[]],
      [0,[0.0,-2.97,-0.79],[]],
      [1,[0.0,0,-0.8],[]],
      [1,[0.0,-1.75,-0.8],[]],
      [1,[0.0,-3.5,-0.8],[]]
  ]],

//Vanilla HEMTT Cargo
  ["a3\Soft_F_Gamma\Truck_01\Truck_01_cargo_F.p3d",[
    [0,[0.0,-0.29,-0.51],[]],
    [0,[0.0,-2.97,-0.51],[]],
    [1,[0.0,0.5,-0.51],[]],
    [1,[0.0,-1.25,-0.51],[]],
    [1,[0.0,-2.97,-0.51],[]]
  ]],

//Boats
//Motorboat civilian
  ["\A3\boat_f_gamma\Boat_Civil_01\Boat_Civil_01_F", [
    [1,		[0,-1.697,-0.874],	[]]
  ]],

//Speedboat minigun
  ["\A3\Boat_F\Boat_Armed_01\Boat_Armed_01_minigun_F.p3d", [
    [1,		[0,2.63701,-2.16123],	[]]
  ]],

//Transport rubber boat
  ["\A3\boat_f\Boat_Transport_01\Boat_Transport_01_F.p3d", [
    [1,		[0,0.0189972,-1.04965],	[]]
  ]],

//Civilian transport boat
  ["\A3\Boat_F_Exp\Boat_Transport_02\Boat_Transport_02_F.p3d", [
    [1, [0,1.233,-0.72029],			[]]
  ]],

//Tanoa boat
  ["\A3\Boat_F_Exp\Boat_Transport_02\Boat_Transport_02_F.p3d",[
      [1,[-0.0615234,0.492443,0.322869],[5,6,2]]
  ]]

];
//Add to weapon sets
jnl_smallVicWeapons = [
  "\A3\Static_F_Gamma\AT_01\AT_01.p3d",					//AT titan, facing to the right
  "\A3\Static_F_Gamma\GMG_01\GMG_01_high_F.p3d",//Static GMG
  "\A3\Static_F_Gamma\HMG_01\HMG_01_high_F.p3d" //Static HMG
];
jnl_largeVicWeapons = [
  "\A3\Static_F_Gamma\AT_01\AT_01.p3d",				  //AT titan, facing to the right
  "\A3\Static_F_Gamma\GMG_01\GMG_01_high_F.p3d",//Static GMG
  "\A3\Static_F_Gamma\HMG_01\HMG_01_high_F.p3d"//Static HMG
];
//Weapon lists for each vehicle.
jnl_allowedWeapons = [
//Offroad
  ["\A3\soft_f\Offroad_01\Offroad_01_unarmed_F", jnl_smallVicWeapons],
//Boxer truck
  ["\A3\soft_f_gamma\van_01\Van_01_transport_F.p3d", jnl_largeVicWeapons],
//Zamak
  ["\A3\soft_f_beta\Truck_02\Truck_02_transport_F", jnl_largeVicWeapons]
];
//Offsets for adding new statics/boxes to the JNL script.
jnl_attachmentOffset = [
//Weapons
  ["\A3\Static_F_Gamma\AT_01\AT_01.p3d",					                       		[-0.5, 0.0, 1.05],	[1,0,0],	0],		//AT titan, facing to the right
  ["\A3\Static_F_Gamma\GMG_01\GMG_01_high_F.p3d",		                       	[0.2, -0.3, 1.7],		[0,1,0],	0],		//Static GMG
  ["\A3\Static_F_Gamma\HMG_01\HMG_01_high_F.p3d",	                      		[0.2, -0.3, 1.7],		[0,1,0],	0],		//Static HMG
//Crates
  ["A3\Weapons_F\Ammoboxes\AmmoVeh_F",			                         				[0,0,0.85],	  			[1,0,0],  1],		//Vehicle ammo create
  ["\A3\Supplies_F_Exp\Ammoboxes\Equipment_Box_F.p3d",		        					[0,0,0.85],	 	   		[1,0,0],  1],		//Equipment box
  ["\A3\Props_F_Orange\Humanitarian\Supplies\PaperBox_01_open_boxes_F.p3d", [0,0,0.85],       	[1,0,0],  1], 	//Stef test supplybox
  ["\A3\Structures_F_Heli\Items\Luggage\PlasticCase_01_medium_F.p3d",       [0,0,0.85],	    		[1,0,0],  1], 	//Stef test Devin crate1
  ["\A3\Weapons_F\Ammoboxes\Proxy_UsBasicAmmoBox.p3d",	                 		[0,0,0.85],		   		[1,0,0],  1], 	//Stef test Devin crate2
  ["\A3\Weapons_F\Ammoboxes\Proxy_UsBasicExplosives.p3d",	              		[0,0,0.85],		   		[1,0,0],  1], 	//Stef test Devin crate3
  ["\A3\Weapons_F\Ammoboxes\Supplydrop.p3d",					                      [0, 0, 0.95],	   		[1,0,0],  1],		//Ammodrop crate
//Other
  ["\A3\Soft_F\Quadbike_01\Quadbike_01_F.p3d",	                         		[0, 0, 1.4],  			[0,1,0],  1]		//Quadbike
];
