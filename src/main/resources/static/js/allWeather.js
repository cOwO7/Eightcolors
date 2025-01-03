document.addEventListener("DOMContentLoaded", () => {
	const weatherForm = document.querySelector("form");
	const weatherContainer = document.getElementById("weatherContainer");

	// baseDate와 baseTime을 설정하는 함수
	function setBaseDateAndTime() {
		const now = new Date();
		const year = now.getFullYear();
		const month = String(now.getMonth() + 1).padStart(2, '0');
		const date = String(now.getDate()).padStart(2, '0');
		const hours = now.getHours();
		const minutes = now.getMinutes();

		function getBaseTime(hours, minutes) {
			const apiTimes = ["0200", "0500", "0800", "1100", "1400", "1700", "2000", "2300"];
			const currentTime = `${String(hours).padStart(2, '0')}${String(minutes).padStart(2, '0')}`;
			for (let i = apiTimes.length - 1; i >= 0; i--) {
				if (currentTime >= apiTimes[i]) {
					return apiTimes[i];
				}
			}
			return apiTimes[apiTimes.length - 1];
		}

		const baseTime = getBaseTime(hours, minutes);
		const baseDate = `${year}${month}${date}`;
		const baseDateInput = document.getElementById("baseDate");
		const baseTimeInput = document.getElementById("baseTime");
		if (baseDateInput) baseDateInput.value = baseDate;
		if (baseTimeInput) baseTimeInput.value = baseTime;
	}

	// 강수 확률 값 정리 함수
	function cleanRainProbability(value) {
		if (typeof value === "string" && value.includes("/")) {
			// "10 / 10" 형식에서 첫 번째 값만 가져옴
			return value.split("/")[0].trim();
		}
		return value || '0%'; // 값이 없으면 기본값 "0%" 반환
	}

	// TMN(최저 기온)과 TMX(최고 기온) 값 보완 함수
	function calculateMissingTMNAndTMX(combinedData) {
		Object.entries(combinedData).forEach(([dateKey, details]) => {
			if (!details.TMN && details.TMP) {
				// TMP 값을 통해 TMN 계산
				if (!details._TMP_LIST) details._TMP_LIST = [];
				details._TMP_LIST.push(parseFloat(details.TMP));
			}

			// TMP 리스트에서 TMN/TMX 계산
			if (details._TMP_LIST) {
				const temps = details._TMP_LIST;
				details.TMN = Math.min(...temps).toFixed(1); // 최저값
				details.TMX = Math.max(...temps).toFixed(1); // 최고값
				delete details._TMP_LIST; // 임시 데이터 삭제
			}
		});
	}

	// SKY 값을 문자열로 변환하는 함수
	function code_value(category, code, weatherForecast) {
		if (category === "SKY" && code) {
			if (code === "1") return "맑음";
			if (code === "3") return "구름 많음";
			if (code === "4") return "흐림";
		}
		if (weatherForecast) return weatherForecast;
		return "-";
	}

	// 날씨 이미지를 가져오는 함수
	function getWeatherImage(sky, fcstTime, weatherForecast) {
		const isNight = parseInt(fcstTime) >= 1800 || (fcstTime >= "0000" && fcstTime < "0600");

		if (sky) {
			if (sky.includes("맑음")) {
				return isNight ? "images/weather/맑음밤.gif" : "images/weather/맑음.gif";
			} else if (sky.includes("구름")) {
				return "images/weather/구름많음.gif";
			} else if (sky.includes("흐림")) {
				return isNight ? "images/weather/흐림밤.gif" : "images/weather/흐림아침.gif";
			} else if (sky.includes("비")) {
				return "images/weather/비.gif";
			} else if (sky.includes("눈")) {
				return "images/weather/함박눈.gif";
			}
		}

		if (weatherForecast) {
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
			}
		}

		return "images/weather/default.gif";
	}

	// 날씨 데이터를 카드로 렌더링
	function renderWeatherCards(combinedData) {
		if (!weatherContainer) {
			console.error("weatherContainer 요소가 존재하지 않습니다.");
			return;
		}

		weatherContainer.innerHTML = '';

		const today = new Date();
		const options = { month: "numeric", day: "numeric" };

		const weatherData = Object.entries(combinedData).map(([dateKey, details], index) => {
			const futureDate = new Date(today);
			futureDate.setDate(today.getDate() + index);

			const skyValue = code_value("SKY", details.SKY, details.weatherForecast);
			const morningRain = cleanRainProbability(details.rainMorning || details.POP || details.rainProbability || '0%');
			const afternoonRain = cleanRainProbability(details.rainAfternoon || details.POP || details.rainProbability || '0%');

			const morningIcon = getWeatherImage(skyValue, '0600', details.weatherForecast);
			const afternoonIcon = getWeatherImage(skyValue, '1800', details.weatherForecast);

			return {
				day: index === 0 ? "오늘" : index === 1 ? "내일" : `D+${index}`,
				date: futureDate.toLocaleDateString("ko-KR", options),
				morningRain: morningRain,
				afternoonRain: afternoonRain,
				morningIcon: morningIcon,
				afternoonIcon: afternoonIcon,
				tempMorning: `${details.TMN || details.minTemperature || '--'}°`,
				tempAfternoon: `${details.TMX || details.maxTemperature || '--'}°`
			};
		});

		weatherData.forEach((data, index) => {
			const card = document.createElement("div");
			card.className = "day-card";
			if (index === 0) card.classList.add("today");

			card.innerHTML = `
                <h3>${data.day}</h3>
                <p>${data.date}</p>
                <div class="weather">
                    <div class="morning">
                        <span>오전</span>
                        <img src="${data.morningIcon}" alt="Morning Weather Icon" class="icon">
                        <span>강수<br />확률: <br />${data.morningRain}</span>
                    </div>
                    <div class="afternoon">
                        <span>오후</span>
                        <img src="${data.afternoonIcon}" alt="Afternoon Weather Icon" class="icon">
                        <span>강수<br />확률: <br /> ${data.afternoonRain}</span>
                    </div>
                </div>
                <div class="temperature">
                    <p>${data.tempMorning} / ${data.tempAfternoon}</p>
                </div>
            `;
			weatherContainer.appendChild(card);
		});
	}

	// 폼 제출 이벤트 처리
	weatherForm.addEventListener("submit", async (event) => {
		event.preventDefault();

		const baseDate = document.getElementById("baseDate").value.trim();
		const baseTime = document.getElementById("baseTime").value.trim();
		const nx = parseInt(document.getElementById("nx").value.trim(), 10);
		const ny = parseInt(document.getElementById("ny").value.trim(), 10);
		const regId = document.getElementById("regId").value.trim();
		const tmFc = document.getElementById("tmFc").value.trim();
		const regIdTemp = document.getElementById("regIdTemp").value.trim();

		try {
			const response = await fetch('/processAllWeather', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({ baseDate, baseTime, nx, ny, regId, tmFc, regIdTemp }),
			});
			if (!response.ok) {
				throw new Error(`Network response was not ok: ${response.status}`);
			}
			const combinedData = await response.json();

			// TMN과 TMX 값 보완
			calculateMissingTMNAndTMX(combinedData);

			// 카드 렌더링
			renderWeatherCards(combinedData);
		} catch (error) {
			console.error("데이터 가져오기 실패:", error);
			alert("데이터를 가져오는 중 문제가 발생했습니다. 다시 시도해주세요.");
		}
	});

	// 페이지 로드 시 baseDate와 baseTime 설정
	setBaseDateAndTime();
});
