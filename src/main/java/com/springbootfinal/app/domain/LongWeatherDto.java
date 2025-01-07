package com.springbootfinal.app.domain;

import lombok.Data;

import java.util.List;

/*@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor*/
@Data
public class LongWeatherDto {

	private Response response;

	@Data
	public static class Response {
		private Header header;
		private Body body;
	}

	@Data
	public static class Header {
		private String resultCode;
		private String resultMsg;
	}

	@Data
	public static class Body {
		private String dataType;
		private Items items;
		private Integer pageNo;
		private Integer numOfRows;
		private Integer totalCount;
	}

	@Data
	public static class Items {
		private List<Item> item;
	}

	@Data
	public static class Item {
		private String regId;       // 예보구역코드
		private List<String> fcstDates; // 예보 날짜 리스트
		private List<String> fcstTimes; // 예보 시간 리스트

		private Integer rnSt4Am;
		private Integer rnSt4Pm;
		private Integer rnSt5Am;
		private Integer rnSt5Pm;
		private Integer rnSt6Am;
		private Integer rnSt6Pm;
		private Integer rnSt7Am;
		private Integer rnSt7Pm;
		private Integer rnSt8;
		private Integer rnSt9;
		private Integer rnSt10;
		private String wf4Am;
		private String wf4Pm;
		private String wf5Am;
		private String wf5Pm;
		private String wf6Am;
		private String wf6Pm;
		private String wf7Am;
		private String wf7Pm;
		private String wf8;
		private String wf9;
		private String wf10;

		// 특정 인덱스의 fcstDate 반환
		public String getFcstDate(int index) {
			if (fcstDates != null && index < fcstDates.size()) {
				return fcstDates.get(index);
			}
			return null;
		}

		// 특정 인덱스의 fcstTime 반환
		public String getFcstTime(int index) {
			if (fcstTimes != null && index < fcstTimes.size()) {
				return fcstTimes.get(index);
			}
			return null;
		}

		public String getWf(int dayIndex) {
			switch (dayIndex) {
				case 4: return wf4Am;
				case 5: return wf5Am;
				case 6: return wf6Am;
				case 7: return wf7Am;
				case 8: return wf8;
				case 9: return wf9;
				case 10: return wf10;
				default: throw new IllegalArgumentException("Invalid day index: " + dayIndex);
			}
		}

		public int getRnSt(int dayIndex) {
			switch (dayIndex) {
				case 4: return rnSt4Am;
				case 5: return rnSt5Am;
				case 6: return rnSt6Am;
				case 7: return rnSt7Am;
				case 8: return rnSt8;
				case 9: return rnSt9;
				case 10: return rnSt10;
				default: throw new IllegalArgumentException("Invalid day index: " + dayIndex);
			}
		}
	}
}
