// 도시, 구/시 데이터를 저장하는 객체
let locations;
locations = {
	"강원특별자치도": {
		reg_code: {
			"regId":"11D10000",
			"regIdTemp":"11D20501"
		},
		districts: [
			"춘천", "원주", "강릉", "동해", "태백", "속초", "삼척",
			"홍천", "횡성", "영월", "평창", "정선", "철원", "화천",
			"양구", "인제", "고성", "양양"
		],
		kor_code: {
			"춘천": "kor5111000000",
			"원주": "kor5113000000",
			"강릉": "kor5115000000",
			"동해": "kor5117000000",
			"태백": "kor5119000000",
			"속초": "kor5121000000",
			"삼척": "kor5123000000",
			"홍천": "kor5172000000",
			"횡성": "kor5173000000",
			"영월": "kor5175000000",
			"평창": "kor5176000000",
			"정선": "kor5177000000",
			"철원": "kor5178000000",
			"화천": "kor5179000000",
			"양구": "kor5180000000",
			"인제": "kor5181000000",
			"고성": "kor5182000000",
			"양양": "kor5183000000"
		}
	},
	"경기도": {
		reg_code: {
			regId:"11B00000",
			regIdTemp:"11B20601"
		},
		districts: [
			"수원", "성남", "의정부", "안양", "부천", "광명", "평택", "동두천",
			"안산", "고양", "과천", "구리", "남양주", "오산", "시흥", "군포",
			"의왕", "하남", "용인", "파주", "이천", "안성", "김포", "화성",
			"광주", "양주", "포천", "여주", "연천군", "가평군", "양평군"
		],
		kor_code: {
			"수원": "kor4111100000",
			"성남": "kor4113100000",
			"의정부": "kor4115000000",
			"안양": "kor4117100000",
			"부천": "kor4119200000",
			"광명": "kor4121000000",
			"평택": "kor4122000000",
			"동두천": "kor4125000000",
			"안산": "kor4127100000",
			"고양": "kor4128100000",
			"과천": "kor4129000000",
			"구리": "kor4131000000",
			"남양주": "kor4136000000",
			"오산": "kor4137000000",
			"시흥": "kor4139000000",
			"군포": "kor4141000000",
			"의왕": "kor4143000000",
			"하남": "kor4145000000",
			"용인": "kor4146100000",
			"파주": "kor4148000000",
			"이천": "kor4150000000",
			"안성": "kor4155000000",
			"김포": "kor4157000000",
			"화성": "kor4159000000",
			"광주": "kor4161000000",
			"양주": "kor4163000000",
			"포천": "kor4165000000",
			"여주": "kor4167000000",
			"연천군": "kor4180000000",
			"가평군": "kor4182000000",
			"양평군": "kor4183000000"
		}
	},
	"경상남도": {
		reg_code: {
			regId:"11H20000",
			regIdTemp:"11H20301"
		},
		districts: [
			"마산시", "창원시", "진주시", "김해시", "밀양시", "통영시", "사천시", "진해시",
			"거제시", "양산시", "하동군", "거창군", "합천군", "창녕군", "함안군", "산청군",
			"의령군", "남해군"
		],
		kor_code: {
			"마산시": "kor4812500000",
			"창원시": "kor4813000000",
			"진주시": "kor4815000000",
			"김해시": "kor4817000000",
			"밀양시": "kor4819000000",
			"통영시": "kor4820000000",
			"사천시": "kor4821000000",
			"진해시": "kor4823000000",
			"거제시": "kor4825000000",
			"양산시": "kor4826000000",
			"하동군": "kor4871000000",
			"거창군": "kor4872000000",
			"합천군": "kor4873000000",
			"창녕군": "kor4874000000",
			"함안군": "kor4875000000",
			"산청군": "kor4876000000",
			"의령군": "kor4877000000",
			"남해군": "kor4878000000"
		}
	},
	"경상북도": {
		reg_code: {
			regId:"11H10000",
			regIdTemp:"11H10501"
		},
		districts: [
			"포항시", "경주시", "김천시", "안동시", "구미시", "영주시",
			"영천시", "상주시", "문경시", "경산시", "의성군", "청송군", "영양군", "영덕군",
			"청도군", "고령군", "성주군", "칠곡군", "예천군", "봉화군", "울진군", "울릉군"
		],
		kor_code: {
			"포항시": "kor4711100000",
			"경주시": "kor4713000000",
			"김천시": "kor4715000000",
			"안동시": "kor4717000000",
			"구미시": "kor4719000000",
			"영주시": "kor4721000000",
			"영천시": "kor4723000000",
			"상주시": "kor4725000000",
			"문경시": "kor4728000000",
			"경산시": "kor4729000000",
			"의성군": "kor4773000000",
			"청송군": "kor4775000000",
			"영양군": "kor4776000000",
			"영덕군": "kor4777000000",
			"청도군": "kor4782000000",
			"고령군": "kor4783000000",
			"성주군": "kor4784000000",
			"칠곡군": "kor4785000000",
			"예천군": "kor4790000000",
			"봉화군": "kor4792000000",
			"울진군": "kor4793000000",
			"울릉군": "kor4794000000"
		}
	},
	"광주광역시": {
		reg_code: {
			regId:"11F20000",
			regIdTemp:"11F20501"
		},
		districts: [
			"동구", "서구", "남구", "북구", "광산구"
		],
		kor_code: {
			"동구": "kor2911000000",
			"서구": "kor2914000000",
			"남구": "kor2915500000",
			"북구": "kor2917000000",
			"광산구": "kor2920000000"
		}
	},
	"대구광역시": {
		reg_code: {
			regId:"11H10000",
			regIdTemp:"11H10701"
		},
		districts: [
			"중구", "동구", "서구", "남구", "북구", "수성구", "달서구", "달성군"
		],
		kor_code: {
			"중구": "kor2711000000",
			"동구": "kor2714000000",
			"서구": "kor2717000000",
			"남구": "kor2720000000",
			"북구": "kor2723000000",
			"수성구": "kor2726000000",
			"달서구": "kor2729000000",
			"달성군": "kor2771000000",
			"군위군": "kor2772000000"
		}
	},
	"서울특별시": {
		reg_code: {
			regId: "11B00000",
			regIdTemp: "11B10101"
		},
		districts: [
			"종로구", "중구", "용산구", "성동구", "광진구", "동대문구",
			"중랑구", "송파구", "강남구", "강동구", "서초구", "동작구",
			"관악구", "금천구", "영등포구", "구로구", "양천구", "강서구",
			"마포구", "서대문구", "은평구", "노원구", "도봉구", "강북구"
		],
		kor_code: {
			"종로구": "kor1111000000",
			"중구": "kor1114000000",
			"용산구": "kor1117000000",
			"성동구": "kor1120000000",
			"광진구": "kor1121500000",
			"동대문구": "kor1123000000",
			"중랑구": "kor1126000000",
			"성북구": "kor1129000000",
			"강북구": "kor1130500000",
			"도봉구": "kor1132000000",
			"노원구": "kor1135000000",
			"은평구": "kor1138000000",
			"서대문구": "kor1141000000",
			"마포구": "kor1144000000",
			"양천구": "kor1147000000",
			"강서구": "kor1150000000",
			"구로구": "kor1153000000",
			"금천구": "kor1154500000",
			"영등포구": "kor1156000000",
			"동작구": "kor1159000000",
			"관악구": "kor1162000000",
			"서초구": "kor1165000000",
			"강남구": "kor1168000000",
			"송파구": "kor1171000000",
			"강동구": "kor1174000000"
		}
	},
	"부산광역시": {
		reg_code: {
			regId: "11H20000",
			regIdTemp: "11H20201"
		},
		districts: [
			"중구", "서구", "동구", "영도구", "부산진구", "동래구",
			"남구", "북구", "해운대구", "사하구", "금정구", "강서구",
			"연제구", "수영구", "사상구", "기장군"
		],
		kor_code: {
			"중구": "kor2611000000",
			"서구": "kor2614000000",
			"동구": "kor2617000000",
			"영도구": "kor2620000000",
			"부산진구": "kor2623000000",
			"동래구": "kor2626000000",
			"남구": "kor2629000000",
			"북구": "kor2632000000",
			"해운대구": "kor2635000000",
			"사하구": "kor2638000000",
			"금정구": "kor2641000000",
			"강서구": "kor2644000000",
			"연제구": "kor2647000000",
			"수영구": "kor2650000000",
			"사상구": "kor2653000000",
			"기장군": "kor2671000000"
		}
	},
	"인천광역시": {
		reg_code: {
			regId: "11B00000",
			regIdTemp: "11B20201"
		},
		districts: [
			"중구", "동구", "미추홀구", "연수구", "남동구", "부평구",
			"계양구", "서구", "강화군", "옹진군"
		],
		kor_code: {
			"중구": "kor2811000000",
			"동구": "kor2814000000",
			"미추홀구": "kor2817700000",
			"연수구": "kor2818500000",
			"남동구": "kor2820000000",
			"부평구": "kor2823700000",
			"계양구": "kor2824500000",
			"서구": "kor2826000000",
			"강화군": "kor2871000000",
			"옹진군": "kor2872000000"
		}
	},
	"대전광역시": {
		reg_code: {
			regId: "11C20000",
			regIdTemp: "11C20401"
		},
		districts: [
			"중구", "동구", "서구", "유성구", "대덕구"
		],
		kor_code: {
			"동구": "kor3011000000",
			"중구": "kor3014000000",
			"서구": "kor3017000000",
			"유성구": "kor3020000000",
			"대덕구": "kor3023000000"
		}
	},
	"울산광역시": {
		reg_code: {
			regId: "11H20000",
			regIdTemp: "11H20101"
		},
		districts: [
			"남구", "동구", "북구", "중구", "울주군"
		],
		kor_code: {
			"중구": "kor3111000000",
			"남구": "kor3114000000",
			"동구": "kor3117000000",
			"북구": "kor3120000000",
			"울주군": "kor3171000000"
		}
	},
	"세종특별자치시": {
		reg_code: {
			regId: "11C20000",
			regIdTemp: "11C20404"
		},
		districts: [
			"세종시", "조치원", "연기군", "소정면"
		],
		kor_code: {
			"세종시": "kor3611000000",
			"조치원": "kor3611025000",
			"연기군": "kor3611031000",
			"소정면": "kor3611039000"
		}
	},
	"전라남도": {
		reg_code: {
			regId: "11F20000",
			regIdTemp: "21F20801"
		},
		districts: [
			"목포", "여수", "순천", "광양", "나주", "진도", "완도",
			"해남", "담양", "장성", "곡성", "영광", "함평", "고흥", "보성"
		],
		kor_code: {
			"목포": "kor4611000000",
			"여수": "kor4613000000",
			"순천": "kor4615000000",
			"광양": "kor4623000000",
			"나주": "kor4617000000",
			"담양": "kor4671000000",
			"곡성": "kor4672000000",
			"구례": "kor4673000000",
			"고흥": "kor4677000000",
			"보성": "kor4678000000",
			"화순": "kor4679000000",
			"장흥": "kor4680000000",
			"강진": "kor4681000000",
			"해남": "kor4682000000",
			"영암": "kor4683000000",
			"무안": "kor4684000000",
			"함평": "kor4686000000",
			"영광": "kor4687000000",
			"장성": "kor4688000000",
			"완도": "kor4689000000",
			"진도": "kor4690000000",
			"신안": "kor4691000000"
		}
	},
	"전라북도": {
		reg_code: {
			regId: "11F20000",
			regIdTemp: "21F20801"
		},
		districts: [
			"전주", "군산", "익산", "정읍", "남원", "김제", "완주",
			"진안", "장수", "임실", "순창", "고창", "부안"
		],
		kor_code: {
			"전주": "kor5211100000",
			"군산": "kor5213000000",
			"익산": "kor5214000000",
			"정읍": "kor5218000000",
			"남원": "kor5219000000",
			"김제": "kor5221000000",
			"완주": "kor5271000000",
			"진안": "kor5272000000",
			"무주": "kor5273000000",
			"장수": "kor5274000000",
			"임실": "kor5275000000",
			"순창": "kor5277000000",
			"고창": "kor5279000000",
			"부안": "kor5280000000"
		}
	},
	"제주특별자치도": {
		reg_code: {
			regId: "11G00000",
			regIdTemp: "11G00201"
		},
		districts: [
			"제주", "서귀포"
		],
		kor_code: {
			"제주": "kor5011000000",
			"서귀포": "kor5013000000"
		}
	},
	"충청남도": {
		reg_code: {
			regId: "11C20000",
			regIdTemp: "11C20101"
		},
		districts: [
			"천안", "아산", "논산", "서산", "보령", "당진", "금산",
			"홍성", "계룡", "태안", "서천", "청양"
		],
		kor_code: {
			"천안": "kor4413100000",
			"공주": "kor4415000000",
			"보령": "kor4418000000",
			"아산": "kor4420000000",
			"서산": "kor4421000000",
			"논산": "kor4423000000",
			"계룡": "kor4425000000",
			"당진": "kor4427000000",
			"금산": "kor4471000000",
			"부여": "kor4476000000",
			"서천": "kor4477000000",
			"청양": "kor4479000000",
			"홍성": "kor4480000000",
			"예산": "kor4481000000",
			"태안": "kor4482500000"
		}
	},
	"충청북도": {
		reg_code: {
			regId: "11C10000",
			regIdTemp: "11C10301"
		},
		districts: [
			"청주", "충주", "제천", "진천", "음성", "옥천", "보은", "단양"
		],
		kor_code: {
			"청주": "kor4311100000",
			"충주": "kor4313000000",
			"제천": "kor4315000000",
			"보은": "kor4372000000",
			"옥천": "kor4373000000",
			"영동": "kor4374000000",
			"증평": "kor4374500000",
			"진천": "kor4375000000",
			"괴산": "kor4376000000",
			"음성": "kor4377000000",
			"단양": "kor4380000000"
		}
	}
};

document.addEventListener("DOMContentLoaded", function () {
	// 현재 날짜와 시간 구하기
	const now = new Date();
	let year = now.getFullYear();
	let month = String(now.getMonth() + 1).padStart(2, '0');  // 월은 0부터 시작하므로 +1
	let date = String(now.getDate()).padStart(2, '0');
	let hours = now.getHours();

	// 조회 시간 (0600 or 1800) 계산
	let forecastTime = "";
	let forecastDate = "";

	if (hours < 6) {
		forecastTime = "1800";
		forecastDate = `${year}${month}${date}`;
	} else if (hours >= 6 && hours < 18) {
		forecastTime = "0600";
		forecastDate = `${year}${month}${date}`;
	} else if (hours >= 18 && hours < 24) {
		forecastTime = "1800";
		forecastDate = `${year}${month}${date}`;
	}

	// 날짜와 시간을 tmFc 필드에 넣기
	const tmFcInput = document.getElementById("tmFc");
	if (tmFcInput) {
		tmFcInput.value = forecastDate + forecastTime;
	} else {
		console.error("tmFc input field is not found.");
	}
});

// 도시 선택 시 중기 지역코드 업데이트
document.addEventListener("DOMContentLoaded", function () {
	// DOM 요소 참조
	const regIdInput = document.getElementById("regId");
	const regIdTempInput = document.getElementById("regIdTemp");
	const citySelector = document.getElementById("city-selector");

	if (!regIdInput || !regIdTempInput || !citySelector) {
		console.error("Required elements (regId, regIdTemp, city-selector) are missing.");
		return;
	}

	// 도시 선택 이벤트
	citySelector.addEventListener("change", function (event) {
		const selectedCity = event.target.value.trim(); // 선택된 도시 이름
		if (!locations[selectedCity]) {
			console.error("해당 도시 데이터가 없습니다:", selectedCity);
			return;
		}

		const regCode = locations[selectedCity]?.reg_code || {};

		// Input 필드 값 설정
		regIdInput.value = regCode.regId || "";
		regIdTempInput.value = regCode.regIdTemp || "";

		// 렌더링 강제 트리거
		regIdInput.dispatchEvent(new Event("change"));
		regIdTempInput.dispatchEvent(new Event("change"));

		updateDistricts(selectedCity); // 구/시 목록 업데이트
	});
});

// 도시 목록을 업데이트
document.addEventListener("DOMContentLoaded", function () {
	const citySelector = document.getElementById("city-selector");

	if (!citySelector) {
		console.error("city-selector element is not found.");
		return;
	}

	// 도시 목록 업데이트
	function updateCityList() {
		citySelector.innerHTML = "<option value=''>도시를 선택하세요</option>"; // 기본 옵션 추가

		// 도시 목록을 동적으로 추가
		for (const city in locations) {
			const option = document.createElement("option");
			option.value = city; // 도시 이름을 값으로 설정
			option.textContent = city; // 도시 이름을 표시
			citySelector.appendChild(option);
		}
	}

	// 도시 목록을 초기화
	updateCityList();
});

// 선택된 city와 district에 따라 korCode를 가져오는 함수
function getKorCode(city, district) {
	const cityData = locations[city];
	if (!cityData) {
		console.error("해당 도시를 찾을 수 없습니다:", city);
		return null;
	}

	const korCode = cityData.kor_code[district];
	if (!korCode) {
		console.error("해당 구/시의 korCode를 찾을 수 없습니다:", district);
		return null;
	}

	return korCode;
}

// 좌표를 가져오는 함수 (korCode를 사용)
function fetchCoordinates(city, district) {
	const korCode = getKorCode(city, district);
	if (!korCode) return;

	// korCode를 사용하여 좌표를 가져옵니다.
	fetch(`/coordinates/${korCode}`)
		.then(response => {
			if (!response.ok) {
				throw new Error(`HTTP error! status: ${response.status}`);
			}
			return response.json();
		})
		.then(data => {
			const nxInput = document.getElementById("nx");
			const nyInput = document.getElementById("ny");
			const latitudeInput = document.getElementById("latitudeNum");
			const longitudeInput = document.getElementById("longitudeNum");

			if (nxInput && nyInput && latitudeInput && longitudeInput) {
				nxInput.value = data.gridX;
				nyInput.value = data.gridY;
				latitudeInput.value = data.latitude;
				longitudeInput.value = data.longitude;
			} else {
				console.error("One or more input fields for coordinates are missing.");
			}
		})
		.catch(error => {
			console.error("좌표 데이터를 가져오는 데 실패했습니다:", error);
		});
}

// 도시 선택 시 구/시 목록을 동적으로 업데이트
function updateDistricts(city) {
	const districtDropdown = document.querySelector('#district-selector + .dropdown-menu');
	if (!districtDropdown) {
		console.error("district-selector dropdown-menu element is not found.");
		return;
	}

	districtDropdown.innerHTML = ""; // 기존 목록 지우기

	const cityData = locations[city];
	if (!cityData) {
		console.error("해당 도시를 찾을 수 없습니다:", city);
		return;
	}

	const districts = cityData.districts || [];
	districts.forEach(district => {
		const listItem = document.createElement('li');
		const link = document.createElement('a');
		link.classList.add('dropdown-item');
		link.href = "#";
		link.textContent = district;
		link.addEventListener('click', function () {
			const districtSelector = document.getElementById("district-selector");
			if (districtSelector) {
				districtSelector.textContent = district;
				fetchCoordinates(city, district); // 구/시를 선택하면 좌표를 가져옴
			} else {
				console.error("district-selector element is not found.");
			}
		});
		listItem.appendChild(link);
		districtDropdown.appendChild(listItem);
	});
}

// 초기화: 기본 도시 설정
document.addEventListener("DOMContentLoaded", function () {
	const defaultCity = "강원특별자치도"; // 기본값
	updateDistricts(defaultCity);

	// 기본값으로 선택된 도시 설정
	const citySelector = document.getElementById("city-selector");
	if (citySelector) {
		citySelector.value = "";
	}
});