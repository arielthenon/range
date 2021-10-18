module range

fn test_int_iter(){
	args := [[i64(27), 11, -5], 
    		 [i64(13), 1, -6], 
 	 		 [i64(-19), -35, -6], 
 	 		 [i64(-88), -29, 8], 
 	 		 [i64(17), -94, 2], 
    		 [i64(30), 45, 6], 
   			 [i64(90), 36, -3], 
 			 [i64(26), -45, -5],  
 			 [i64(-88), -74, 4],
   			 [i64(-38), 23, -6]]
	expected := [[i64(27), 22, 17, 12],
				[i64(13), 7],
				[i64(-19), -25, -31],
				[i64(-88), -80, -72, -64, -56, -48, -40, -32],
				[]i64{len:0},
				[i64(30), 36, 42],
				[i64(90), 87, 84, 81, 78, 75, 72, 69, 66, 63, 60, 57, 54, 51, 48, 45, 42, 39],
				[i64(26), 21, 16, 11, 6, 1, -4, -9, -14, -19, -24, -29, -34, -39, -44],
				[i64(-88), -84, -80, -76],
				[]i64{len:0}]

	for i, values in args {
		r := int_iter(start: values[0], stop: values[1], step:values[2])
		for j, n in r {
			assert n == expected[i][j]
		}
		assert r.len == expected[i].len
	}
}


fn test_float_iter() {
	args := [[2.1245007882430293, 9.475733123176873, 2.2990402233671574],
			[-7.058872968509806, 7.971784986016715, 1.98165413807058],
			[-5.739216620975403, -0.3467859289458932, 2.2127178067713644],
			[-9.209885589461972, 7.79279980826675, 2.2970844754765203],
			[-2.725199519483912, 0.9910706292390667, 1.8984112554828725],
			[-0.9271140474614441, 7.218957413200016, 2.6191648319065575],
			[5.262317826776403, 7.240009846622204, -1.79748275763641],
			[11.564341866821202, -9.621670065975092, -2.8008121961157837],
			[5.998333705124921, -1.4618360622239415, -2.9899847840125],
			[3.74665735975508, -9.58065602921323, 2.089982105981443]]
	expected := [[2.1245007882430293, 4.423541011610187, 6.722581234977344, 9.021621458344502], 
				[-7.058872968509806, -5.077218830439225, -3.0955646923686446, -1.113910554298064, 0.867743583772515, 2.849397721843095, 4.831051859913678, 6.812705997984257], 
				[-5.739216620975403, -3.526498814204039, -1.3137810074326746], 
				[-9.209885589461972, -6.912801113985452, -4.615716638508932, -2.3186321630324116, -0.021547687555891315, 2.275536787920629, 4.572621263397149, 6.8697057388736695], 
				[-2.725199519483912, -0.8267882640010393], 
				[-0.9271140474614441, 1.6920507844451134, 4.311215616351671, 6.930380448258228], 
				[]f64{}, 
				[11.564341866821202, 8.763529670705418, 5.962717474589635, 3.161905278473851, 0.36109308235806736, -2.4397191137577163, -5.2405313098735, -8.041343505989282], 
				[5.998333705124921, 3.008348921112421, 0.018364137099920796], 
				[]f64{}]

	for i, values in args {
		r := float_iter(start:values[0], stop:values[1], step:values[2])
		for j, n in r {
			if !n.eq_epsilon(expected[i][j]) {
				println('$n,  ${expected[i][j]}')
			}
			assert n.eq_epsilon(expected[i][j])
		}
		assert r.len == expected[i].len
	}
}

fn test_lin_iter() {
	limits := [[1.2406537780235105, 11.347723458996064], [7.934211647857726, -3.7058956024157084], [10.244703943148405, -6.008335534940258], [-6.071150084691839, -5.846906010513566], [10.367120987381458, -9.851326072515677], [0.8136613633305672, -1.0730190759873128], [10.965127527440444, 8.068742222821108], [-0.7509669252729427, -2.9004178591848113], [-9.673319044566949, 3.705538702478055], [-8.129098138805718, 2.753071722916834], [1.9788425271898529, 10.207068414571822], [2.6478453874582932, -1.8392282826138064]]
	lens := [2, 5, 6, 3, 2, 4, 5, 4, 4, 1, 2, 0]
	endpoints := [true, true, false, true, false, true, false, true, false, false, true, false]

	expected := [[1.2406537780235105, 11.347723458996064],
				[7.934211647857726, 5.024184835289367, 2.114158022721009, -0.7958687898473507, -3.7058956024157084],
				[10.244703943148405, 7.535864030133627, 4.82702411711885, 2.1181842041040735, -0.5906557089107043, -3.299495621925482],
				[-6.071150084691839, -5.959028047602702, -5.846906010513566],
				[10.367120987381458, 0.2578974574328896],
				[0.8136613633305672, 0.1847678835579405, -0.44412559621468617, -1.0730190759873128],
				[10.965127527440444, 10.385850466516576, 9.80657340559271, 9.227296344668842, 8.648019283744976],
				[-0.7509669252729427, -1.4674505699102323, -2.183934214547522, -2.9004178591848113],
				[-9.673319044566949, -6.328604607805698, -2.9838901710444468, 0.36082426571680415],
				[-8.129098138805718],
				[1.9788425271898529, 10.207068414571822],
				[]f64{}]
	
	for i, lim in limits {
		l := lin_iter(start: lim[0], stop: lim[1], len:lens[i], endpoint:endpoints[i])
		for j, n in l {
			assert n.eq_epsilon(expected[i][j])
		}
		assert l.len == expected[i].len
	}
}