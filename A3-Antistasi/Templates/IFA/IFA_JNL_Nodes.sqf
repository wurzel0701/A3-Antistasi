jnl_vehicleHardpoints append [

//Allies
//GMC
  ["\WW2\Assets_m\Vehicles\Trucks_m\IF_Gmc353Truck.p3d",[
    [1,		[0,-2,-0.6],	[1,2,3,4,5,6,7,8,9,10]]
  ]],

//Austin
  ["\WW2\Assets_m\Vehicles\Trucks_m\DD_AustinK5.p3d",[
    [1,		[0,-1,-0.9],	[1,2,3,4,5,6,7,8,9,10]]
  ]],

//Axis
//Opel Blitz
  ["\WW2\Assets_m\Vehicles\Trucks_m\IF_Opelblitz.p3d",[
    [1,		[0,-1.5,-0.10],	[1,2,3,4,5,6,7,8,9,10]]
  ]],

//Opel Blitz Covered
  ["\WW2\Assets_m\Vehicles\Trucks_m\IF_Opelblitz_Tent.p3d",[
    [1,		[0,-1.5,-0.10],					[1,2,3,4,5,6,7,8,9,10]]
  ]],

//Sd. Kfz. 7/1
  ["\WW2\Assets_m\Vehicles\WheeledAPC_m\IF_SdKfz_7.p3d",[
    [1,		[0,-1.7,-0.8],		[5,6,7,8,9,10,11]]
  ]],

//Commintern
//Studebaker
  ["\WW2\Assets_m\Vehicles\Trucks_m\IF_Us6.p3d",[
    [1,		[0,-0.82,0.17],					[2,3,4,5,6,7,8]]
  ]]

];
//Add to the weapon sets
jnl_smallVicWeapons append [];
jnl_largeVicWeapons append [];
//Weapon lists for each vehicle.
jnl_allowedWeapons append [];
//Offsets for adding new statics/boxes to the JNL script.
jnl_attachmentOffset append [
//weapons

//Crates
  ["\WW2\Assets_m\Weapons\Ammoboxes_m\IF_GER_Ammo.p3d",			[0,0,0.85],				[1,0,0],				1],		//ifa ammo
  ["\WW2\Assets_m\Weapons\Ammoboxes_m\IF_SU_Ammo.p3d",			[0,0,0.85],				[1,0,0],				1]		//ifa ammo
//Other

];
