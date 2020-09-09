//JNL mounting nodes for cargo and statics.
logistics_vehicleHardpoints append [
  //hardpoints needs to be redone
  //4x4s
  //Dodge 3/4
  ["\uns_wheeled_w\m37b\uns_m37b1.p3d",[
    [1,             [0,-1.4,-0.9],          [1,2,5,6]],
    [1,             [0,-2.2,-0.9],          [3,4]]
  ]],
  //6x6s
  //2.5T -- Yes, that is the model path from config viewer...
  ["uns_m35\uns_M35A2",[
    [1,             [0,0.05,-0.57],         [3,4]],
    [1,             [0,-0.75,-0.57],        [5,6]],
    [1,             [0,-1.55,-0.57],        [7,8]],
    [1,             [0,-2.35,-0.57],        [9,10]],
    [1,             [0,-3.1,-0.57],         [1,2]]
  ]],
  //ZIL
  ["uns_wheeled_e\zil157\uns_zil157.p3d",[
    [1,             [0,0.35,1.35],          [11,12]],
    [1,             [0,-0.45,1.35],         [1,2,3,4]],
    [1,             [0,-1.25,1.35],         [5,6]],
    [1,             [0,-2.05,1.35],         [7,8]],
    [1,             [0,-2.8,1.35],          [9,10]]
  ]],
  //Ural
  ["\uns_wheeled_e\ural\uns_ural.p3d",[
    [1,             [0,-0.1,-0.02],         [12,13]],
    [1,             [0,-0.85,-0.02],        [2,3,4,5]],
    [1,             [0,-1.65,-0.02],        [6,7]],
    [1,             [0,-2.45,-0.02],        [8,9]],
    [1,             [0,-3.2,-0.02],         [10,11]]
  ]]
  //8x8s

  //Boats

];

//Offsets for adding new statics/boxes to the JNL script.
logistics_attachmentOffset append [];

//all vehicles with jnl loading nodes where the nodes are not located in the open, this can be because its inside the vehicle or it has a cover over the loading plane.
logistics_coveredVehicles append [];

//if you want a weapon to be loadable you need to add it to this as a array of [model, [blacklist specific vehicles]], 
//if the vehicle is in the coveredVehicles array dont add it to the blacklist in this array.
logistics_weapons append [];
