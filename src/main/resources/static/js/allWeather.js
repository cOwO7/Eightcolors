document.addEventListener("DOMContentLoaded", () => {
	const weatherForm = document.querySelector("form");
	const combinedWeatherTableBody = document.getElementById("combinedWeatherTableBody");
	const weatherContainer = document.getElementById("weatherContainer");

	// 날씨 이미지 가져오기 함수
	function getWeatherImage(sky, fcstTime, weatherForecast) {
		const isNight = parseInt(fcstTime) >= 1800 || (fcstTime >= "0000" && fcstTime < "0600");

		// 우선 `sky`를 기준으로 처리
		if (sky) {
			switch (sky) {
				case "맑음":
					return isNight ? "images/weather/맑음밤.gif" : "images/weather/맑음.gif";
				case "구름 많음":
					return "images/weather/구름많음.gif";
				case "흐림":
					return isNight ? "images/weather/흐림밤.gif" : "images/weather/흐림아침.gif";
				case "비":
					return "images/weather/비.gif";
				case "눈":
					return "images/weather/함박눈.gif";
				default:
					return "images/weather/default.gif";
			}
		}

		// `sky` 값이 없으면 `weatherForecast`를 기준으로 처리
		if (weatherForecast) {
			console.log("weatherForecast value:", weatherForecast); // 확인용 로그
			if (weatherForecast.includes("맑음")) {
				return isNight ? "images/weather/맑음밤.gif" : "images/weather/맑음.gif";
			} else if (weatherForecast.includes("구름")) {
				return "images/weather/구름많음.gif";
			} else if (weatherForecast.includes("흐림")) {
				return isNight ? "images/weather/흐림밤.gif" : "images/weather/흐림아침.gif";
			} else if (weatherForecast.includes("비")) {
				return "images/weather/비.gif";
			} else if (weatherForecast.includes("눈")) {
				return "images/weather/함박눈.gif";
			} else {
				return "images/weather/default.gif";
			}
		}


		// 기본 값 반환
		return "images/weather/default.gif";
	}



	// 코드값을 텍스트로 변환하는 함수
	/*function code_value(category, code) {
		let value = "-";
		if (code) {
			if (category === "SKY") {
				if (code === "1" || "맑음") value = "맑음";
				else if (code === "3" || "구름많음") value = "구름 많음";
				else if (code === "4" || "흐림") value = "흐림";
			} else if (category === "PTY") {
				if (code === "0") value = "없음";
				else if (code === "1") value = "비";
				else if (code === "2") value = "비/눈";
				else if (code === "3") value = "눈";
				else if (code === "5") value = "빗방울";
				else if (code === "6") value = "빗방울눈날림";
				else if (code === "7") value = "눈날림";
			}
		}
		return value;
	}*/
	function code_value(category, code, weatherForecast) {
		let value = "-";

		if (code) {
			if (category === "SKY") {
				if (code === "1" || weatherForecast.includes("맑음")) value = "맑음";
				else if (code === "3" || weatherForecast.includes("구름")) value = "구름 많음";
				else if (code === "4" || weatherForecast.includes("흐림")) value = "흐림";
			} else if (category === "PTY") {
				if (code === "0") value = "없음";
				else if (code === "1") value = "비";
				else if (code === "2") value = "비/눈";
				else if (code === "3") value = "눈";
				else if (code === "5") value = "빗방울";
				else if (code === "6") value = "빗방울눈날림";
				else if (code === "7") value = "눈날림";
			}
		} else if (weatherForecast) {
			if (weatherForecast.includes("맑음")) value = "맑음";
			else if (weatherForecast.includes("구름")) value = "구름 많음";
			else if (weatherForecast.includes("흐림")) value = "흐림";
			else if (weatherForecast.includes("비")) value = "비";
			else if (weatherForecast.includes("눈")) value = "눈";
		}

		return value;
	}


	// 폼 제출 이벤트 처리
	weatherForm.addEventListener("submit", async (event) => {
		event.preventDefault(); // 폼 제출로 인한 페이지 리로드 방지

		// 입력 필드에서 값 가져오기
		const baseDate = document.getElementById("baseDate").value.trim();
		const baseTime = document.getElementById("baseTime").value.trim();
		const nx = parseInt(document.getElementById("nx").value.trim(), 10);
		const ny = parseInt(document.getElementById("ny").value.trim(), 10);
		const regId = document.getElementById("regId").value.trim();
		const tmFc = document.getElementById("tmFc").value.trim();
		const regIdTemp = document.getElementById("regIdTemp").value.trim();

		try {
			// API 요청 보내기
			const response = await fetch('/processAllWeather', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json',
				},
				body: JSON.stringify({
					baseDate,
					baseTime,
					nx,
					ny,
					regId,
					tmFc,
					regIdTemp,
				}),
			});
			if (!response.ok) {
				throw new Error(`Network response was not ok: ${response.status}`);
			}
			const combinedData = await response.json();
			console.log("Fetched Data:", combinedData);
			addCombinedDataToTable(combinedData);
			renderWeatherCards(combinedData);
		} catch (error) {
			console.error("데이터 가져오기 실패:", error);
			alert("데이터를 가져오는 중 문제가 발생했습니다. 다시 시도해주세요.");
		}
	});

	// 테이블에 데이터 추가 함수
	const addCombinedDataToTable = (combinedData) => {
		if (!combinedWeatherTableBody) {
			console.error("combinedWeatherTableBody 요소가 존재하지 않습니다.");
			return;
		}

		combinedWeatherTableBody.innerHTML = ''; // 기존 데이터 삭제

		const sortedData = Object.entries(combinedData).sort(([dateA], [dateB]) => dateA.localeCompare(dateB));

		sortedData.forEach(([dateKey, details]) => {
			const row = document.createElement("tr");

			const isShortTerm = details.SKY || details.POP; // 단기 예보 여부 확인

			row.innerHTML = `
            <td>${dateKey}</td>
            <td>${isShortTerm ? '단기 예보' : '중기 예보'}</td>
            <td>${details.weatherForecast || code_value("SKY", details.SKY) || '--'}</td>
            <td>${details.POP || details.rainProbability || '--'}</td>
            <td>${details.TMN || details.minTemperature || '--'}</td>
            <td>${details.TMX || details.maxTemperature || '--'}</td>
        `;

			combinedWeatherTableBody.appendChild(row);
		});
	};


	// 날씨 데이터를 카드로 렌더링
	const renderWeatherCards = (combinedData) => {
		if (!weatherContainer) {
			console.error("weatherContainer 요소가 존재하지 않습니다.");
			return;
		}

		weatherContainer.innerHTML = ''; // 기존 카드 삭제

		const today = new Date();
		const options = { month: "numeric", day: "numeric" }; // Format: MM.DD

		const weatherData = Object.entries(combinedData).map(([dateKey, details], index) => {
			const futureDate = new Date(today);
			futureDate.setDate(today.getDate() + index);

			const skyValue = code_value("SKY", details.SKY);
			const ptyValue = code_value("PTY", details.PTY);

			return {
				day: index === 0 ? "오늘" : index === 1 ? "내일" : `D+${index}`,
				date: futureDate.toLocaleDateString("ko-KR", options),
				icon: getWeatherImage(skyValue, details.fcstTime || '1200'),
				tempMorning: `${details.TMN || details.TMP || details.minTemperature || '--'}°`,
				tempAfternoon: `${details.TMX || details.maxTemperature || '--'}°`,
				rainMorning: `${details.POP || details.rainProbability || '--'}%`,
				rainAfternoon: `${details.POP || details.rainProbability || '--'}%`
			};
		});

		weatherData.forEach((data, index) => {
			const card = document.createElement("div");
			card.className = "day-card";
			if (index === 0) card.classList.add("today");

			card.innerHTML = `
            <h3>${data.day}</h3>
            <p>${data.date}</p>
            <img src="${data.icon}" alt="Weather Icon" class="icon">
            <p class="temp">${data.tempMorning} / ${data.tempAfternoon}</p>
            <p class="rain">🌧 ${data.rainMorning} / ${data.rainAfternoon}</p>
        `;
			weatherContainer.appendChild(card);
		});
	};

});
