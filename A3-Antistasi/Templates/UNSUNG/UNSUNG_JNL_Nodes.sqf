//JNL mounting nodes for cargo and statics.
jnl_vehicleHardpoints append [
//4x4s
//Dodge 3/4
  ["\uns_wheeled_w\m37b\uns_m37b1.p3d",[
    [1,         [0,-2,-0.8],    [1,2,3,4,5,6]  ]
  ]],
//6x6s
//2.5T -- Yes, that is the model path from config viewer...
  ["uns_m35\uns_M35A2",[
    [1,         [0,-0.5,-0.5],    [1,2,3,4]  ],
    [1,         [0,-2.5,-0.5],    [5,6,7,8]  ]
  ]],
//ZIL
  ["uns_wheeled_e\zil157\uns_zil157.p3d",[
    [1,         [0,-0.3,1.3],    [12,11,1,2,3,4]  ],
    [1,         [0,-2.2,1.3],    [5,6,7,8,9,10]  ]
  ]],
//Ural
  ["\uns_wheeled_e\ural\uns_ural.p3d",[
    [1,         [0,-0.6,0],    [1,2,3,4,11,12]  ],
    [1,         [0,-2.6,0],    [5,6,7,8,9,10]  ]
  ]]
//8x8s

//Boats

];
//Add to the weapon sets
jnl_smallVicWeapons append [];
jnl_largeVicWeapons append [];
//Weapon lists for each vehicle.
jnl_allowedWeapons append [];
//Offsets for adding new statics/boxes to the JNL script.
jnl_attachmentOffset append [];
