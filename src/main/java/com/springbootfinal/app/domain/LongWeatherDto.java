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
				/*case 4: return wf4Am;
				case 5: return wf5Am;
				case 6: return wf6Am;
				case 7: return wf7Am;
				case 8: return wf8;
				case 9: return wf9;
				case 10: return wf10;*/
				case 4: return (this.wf4Am != null) ? this.wf4Am : "--";
				case 5: return (this.wf5Am != null) ? this.wf5Am : "--";
				case 6: return (this.wf6Am != null) ? this.wf6Am : "--";
				case 7: return (this.wf7Am != null) ? this.wf7Am : "--";
				case 8: return (this.wf8 != null) ? this.wf8 : "--";
				case 9: return (this.wf9 != null) ? this.wf9 : "--";
				case 10: return (this.wf10 != null) ? this.wf10 : "--";
				default: throw new IllegalArgumentException("Invalid day index: " + dayIndex);
			}
		}

		public int getRnSt(int dayIndex) {
			switch (dayIndex) {
				//case 4: return rnSt4Am;
				//case 5: return rnSt5Am;
				//case 6: return rnSt6Am;
				//case 7: return rnSt7Am;
				//case 8: return rnSt8;
				//case 9: return rnSt9;
				//case 10: return rnSt10;
				case 4:	return (this.rnSt4Am != null) ? this.rnSt4Am.intValue() : 0;
				case 5: return (this.rnSt5Am != null) ? this.rnSt5Am.intValue() : 0;
				case 6: return (this.rnSt6Am != null) ? this.rnSt6Am.intValue() : 0;
				case 7: return (this.rnSt7Am != null) ? this.rnSt7Am.intValue() : 0;
				case 8: return (this.rnSt8 != null) ? this.rnSt8.intValue() : 0;
				case 9: return (this.rnSt9 != null) ? this.rnSt9.intValue() : 0;
				case 10: return (this.rnSt10 != null) ? this.rnSt10.intValue() : 0;
				default: throw new IllegalArgumentException("Invalid day index: " + dayIndex);
			}
		}
	}
}
