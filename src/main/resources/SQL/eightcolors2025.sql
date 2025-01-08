CREATE DATABASE IF NOT EXISTS eightcolors2025; -- 데이터베이스 생성

use eightcolors2025; -- 데이터베이스 접속

-- 1. 관리자 계정 테이블
CREATE TABLE IF NOT EXISTS admin_users (
                                           admin_user_no BIGINT AUTO_INCREMENT PRIMARY KEY,            		   -- 관리자 번호 (PK)
                                           admin_id VARCHAR(50) NOT NULL UNIQUE,                         		 -- 관리자 계정명 (로그인 ID)
                                           admin_passwd VARCHAR(255) NOT NULL,                          		  -- 비밀번호 (암호화 저장)
                                           admin_name VARCHAR(100) NOT NULL                               		-- 관리자 이름
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 2. 회원가입 테이블
CREATE TABLE IF NOT EXISTS users (
                                     user_no BIGINT AUTO_INCREMENT PRIMARY KEY,                   		  -- 회원 번호 (PK)
                                     id VARCHAR(100) NOT NULL UNIQUE,                           	 		  -- 일반 아이디
                                     passwd VARCHAR(255) NOT NULL,                                			  -- 비밀번호
                                     email VARCHAR(255),                                          			  -- 이메일
                                     phone VARCHAR(100),                                         			   -- 휴대폰번호
                                     phone_verfiy INT DEFAULT 0,                                 			   -- 전화번호 인증 여부
                                     name VARCHAR(100),                                           			  -- 이름
                                     zipcode VARCHAR(50),                                         			  -- 우편번호
                                     address1 VARCHAR(255),                                      			   -- 주소
                                     address2 VARCHAR(255),                                      			   -- 상세주소
                                     loginType ENUM('local', 'google', 'kakao', 'naver') DEFAULT 'local', 		 -- 로그인 매개체
                                     provider_id VARCHAR(255),                                     			 -- 소셜 로그인 제공자 ID
                                     regdate DATETIME DEFAULT CURRENT_TIMESTAMP,                  		  -- 회원가입일
                                     point INT DEFAULT 0                                         			   -- 포인트
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 3. 숙소 상세페이지 테이블
CREATE TABLE IF NOT EXISTS residence (
                                         resid_no BIGINT AUTO_INCREMENT PRIMARY KEY,                    			-- 숙소 번호 (PK)
                                         resid_name VARCHAR(255) NOT NULL,                            				  -- 숙소 이름
                                         resid_description TEXT,                                     					   -- 숙소 상세 설명
                                         resid_address VARCHAR(255),                                    				-- 숙소 주소
                                         resid_type ENUM('resort', 'hotel', 'pension') NOT NULL,       			 -- 숙소 유형
                                         checkin_date DATE,                                       				 	     -- 체크인 날짜
                                         checkout_date DATE,                                           				 -- 체크아웃 날짜
                                         total_price DECIMAL(10, 2),                                  				  -- 원가
                                         discount_rate INT DEFAULT 0,                        					  -- 할인율
                                         discounted_price DECIMAL(10, 2) AS (total_price * (1 - discount_rate / 100)) STORED, 	-- 할인된 가격
                                         rating DECIMAL(2, 1),                                         				 -- 평균 평점
                                         resid_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP        		      	   -- 등록일
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 4. 예약 페이지 테이블
CREATE TABLE IF NOT EXISTS reservations (
                                            pay_no BIGINT AUTO_INCREMENT PRIMARY KEY,       				   -- 결제 번호 (PK)
                                            user_no BIGINT NOT NULL,                        					   -- 회원 번호 (FK)
                                            resid_no BIGINT NOT NULL,                        					  -- 숙소 번호 (FK)
                                            total_price DECIMAL(10, 2),                    					    -- 가격
                                            use_point INT DEFAULT 0,                       					    -- 사용된 포인트
                                            pay_date DATETIME DEFAULT CURRENT_TIMESTAMP,   				    -- 결제일자
                                            status ENUM('결제완료', '결제취소') DEFAULT '결제완료',         			  -- 결제 상태 (기본값: 결제완료)
                                            FOREIGN KEY (user_no) REFERENCES users(user_no) ON DELETE CASCADE ON UPDATE CASCADE,
                                            FOREIGN KEY (resid_no) REFERENCES residence(resid_no) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 5. 후기/댓글 테이블
CREATE TABLE IF NOT EXISTS reviews (
                                       review_id BIGINT AUTO_INCREMENT PRIMARY KEY,            -- 리뷰 ID (PK)
                                       resid_no BIGINT NOT NULL,                              			 -- 숙소 번호 (FK)
                                       user_id BIGINT NOT NULL,                                			-- 작성자 ID
                                       rating INT CHECK (rating BETWEEN 1 AND 5),            	  -- 평점 (1 ~ 5)
                                       comment TEXT,                                         			  -- 후기 내용
                                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,         -- 작성일
                                       FOREIGN KEY (resid_no) REFERENCES residence(resid_no)   -- 숙소 테이블과 연결
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- 6. 출석 로그 테이블
CREATE TABLE IF NOT EXISTS attendance_logs (
                                               log_no BIGINT AUTO_INCREMENT PRIMARY KEY,                      		-- 로그 번호 (PK)
                                               user_no BIGINT NOT NULL,                                    			   -- 회원 번호 (FK)
                                               provider_id VARCHAR(255),                                      			-- 소셜 로그인 제공자 ID
                                               point_received INT NOT NULL,                              			     -- 지급된 포인트
                                               check_date DATE NOT NULL,                                   			   -- 출석 체크 날짜
                                               UNIQUE (user_no, check_date),                                 			 -- 같은 날 중복 출석 체크 방지
                                               FOREIGN KEY (user_no) REFERENCES users(user_no) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 7. 숙소 사진 테이블
CREATE TABLE IF NOT EXISTS property_photos (
                                               photo_no BIGINT AUTO_INCREMENT PRIMARY KEY,                  		 	 -- 사진 ID (PK)
                                               resid_no BIGINT NOT NULL,                                   			   	-- 숙소 번호 (FK)
                                               thumbnailUrls VARCHAR(255) DEFAULT NULL,
                                               photo_url01 VARCHAR(255) DEFAULT NULL,                            			   -- 사진 URL
                                               photo_url02 VARCHAR(255) DEFAULT NULL,                             			   -- 사진 URL
                                               photo_url03 VARCHAR(255) DEFAULT NULL,                            			   -- 사진 URL
                                               photo_url04 VARCHAR(255) DEFAULT NULL,                            			   -- 사진 URL
                                               photo_url05 VARCHAR(255) DEFAULT NULL,                             			   -- 사진 URL
                                               photo_url06 VARCHAR(255) DEFAULT NULL,                            			   -- 사진 URL
                                               photo_url07 VARCHAR(255) DEFAULT NULL,                            			   -- 사진 URL
                                               photo_url08 VARCHAR(255) DEFAULT NULL,                            			   -- 사진 URL
                                               photo_url09 VARCHAR(255) DEFAULT NULL,                            			   -- 사진 URL
                                               photo_url10 VARCHAR(255) DEFAULT NULL,                            			   -- 사진 URL
                                               FOREIGN KEY (resid_no) REFERENCES residence(resid_no) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci

-- 8. 답변 테이블
CREATE TABLE IF NOT EXISTS answers (
                                       answer_no BIGINT AUTO_INCREMENT PRIMARY KEY,       	          		  -- 답변 번호 (PK)
                                       inquiry_no BIGINT NOT NULL,                                 			   -- 문의 번호 (FK)
                                       admin_user_no BIGINT NOT NULL,                        	   		     -- 관리자 번호 (FK)
                                       content TEXT NOT NULL,                                     			    -- 답변 내용
                                       answer_date DATETIME DEFAULT CURRENT_TIMESTAMP,           		     -- 답변 작성일
                                       FOREIGN KEY (inquiry_no) REFERENCES inquiries(inquiry_no) ON DELETE CASCADE,
                                       FOREIGN KEY (admin_user_no) REFERENCES admin_users(admin_user_no) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 9. 공지사항 테이블
CREATE TABLE IF NOT EXISTS notices (
                                       notice_no BIGINT AUTO_INCREMENT PRIMARY KEY,               		    -- 공지사항 번호 (PK)
                                       admin_user_no BIGINT NOT NULL,                            			     -- 관리자 번호 (FK)
                                       title VARCHAR(255) NOT NULL,                             			      -- 공지사항 제목
                                       content TEXT NOT NULL,                                       			  -- 공지사항 내용
                                       notice_date DATETIME DEFAULT CURRENT_TIMESTAMP,         		       -- 작성일
                                       is_active TINYINT(1) DEFAULT 1,                               			  -- 활성 여부 (1: 활성, 0: 비활성)
                                       FOREIGN KEY (admin_user_no) REFERENCES admin_users(admin_user_no) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-----------------------------------------------------------------------------------------------------------------------------

-- 트리거: 답변 작성 시 문의 상태 변경

DELIMITER $$
CREATE TRIGGER update_inquiry_status_after_answer
    AFTER INSERT ON answers
    FOR EACH ROW
BEGIN
    UPDATE inquiries
    SET status = 'answered'
    WHERE inquiry_no = NEW.inquiry_no;
END $$
DELIMITER ;

-----------------------------------------------------------------------------------------------------------------------------

수정된 주의사항, 테이블 생성 순서, ERD 관계 요약은 아래와 같습니다.

주의사항
외래 키 참조 순서
외래 키(Foreign Key)가 있는 테이블은 반드시 참조되는 테이블이 먼저 생성되어야 합니다.
예: users 테이블이 먼저 생성된 후, 이를 참조하는 reservations, reviews 등이 생성되어야 합니다.

외래 키 제약 조건

ON DELETE CASCADE: 참조된 데이터가 삭제될 경우, 연관된 데이터도 자동으로 삭제됩니다.
       ON UPDATE CASCADE: 참조된 데이터가 수정될 경우, 연관된 데이터도 자동으로 업데이트됩니다.
              이 설정은 데이터의 무결성을 유지하고 수동으로 삭제나 수정 작업을 줄이기 위해 포함되었습니다.
              인코딩
              모든 테이블은 UTF-8(MB4) 설정으로 생성되었으며, 다국어 데이터를 저장할 수 있습니다.

              트리거
              answers 테이블에 답변이 작성되면 자동으로 inquiries 테이블의 상태(status)가 'answered'로 업데이트됩니다.
              트리거를 사용할 때는 정확한 동작을 확인하기 위해 테스트 환경에서 검증하세요.

              -----------------------------------------------------------------------------------------------------------------------------

              테이블 생성 순서

              1. admin_users: 관리자 계정 테이블, users: 회원가입 테이블


              2. residence: 숙소 상세 정보 테이블


              3. reservations: 예약 정보 테이블, reviews: 후기/댓글 테이블
              attendance_logs: 출석 로그 테이블, property_photos: 숙소 사진 테이블

              4. inquiries: 고객센터 문의 테이블, answers: 답변 테이블

              -----------------------------------------------------------------------------------------------------------------------------

              ERD 관계 요약

              admin_users
              admin_user_no → answers.admin_user_no (1:N 관계)
              관리자 계정은 여러 답변을 작성할 수 있음.

              users
              user_no → reservations.user_no (1:N 관계)
              한 회원은 여러 예약을 가질 수 있음.
              user_no → reviews.user_no (1:N 관계)
              한 회원은 여러 리뷰를 작성할 수 있음.
              user_no → attendance_logs.user_no (1:N 관계)
              한 회원은 여러 출석 로그를 가질 수 있음.
              user_no → inquiries.user_no (1:N 관계)
              한 회원은 여러 문의를 작성할 수 있음.

              residence
              resid_no → reservations.resid_no (1:N 관계)
              한 숙소는 여러 예약 정보를 가질 수 있음.
              resid_no → reviews.resid_no (1:N 관계)
              한 숙소는 여러 리뷰를 받을 수 있음.
              resid_no → property_photos.resid_no (1:N 관계)
              한 숙소는 여러 사진을 가질 수 있음.

              inquiries
              inquiry_no → answers.inquiry_no (1:N 관계)
              한 문의는 여러 답변을 가질 수 있음.


-- 기상청 nx,ny 좌표 테이틀
              CREATE TABLE weather_coordinate (
              kor_code VARCHAR(20) PRIMARY KEY,       -- 행정구역 코드 (예: kor1111000000)
              area_name VARCHAR(100) NOT NULL,        -- 지역 이름 (예: 서울특별시 종로구)
              grid_x INT NOT NULL,                    -- 격자 X 좌표 (nx)
              grid_y INT NOT NULL,                    -- 격자 Y 좌표 (ny)
              longitude DECIMAL(9,6) NOT NULL,        -- 경도 (소수점 6자리까지)
              latitude DECIMAL(9,6) NOT NULL,         -- 위도 (소수점 6자리까지)
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 데이터 생성 시각
              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- 데이터 수정 시각
              );

-- 서울
-- 서울특별시 종로구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1111000000', '서울특별시 종로구', 60, 127, 126.0, 37.5727);
-- 서울특별시 중구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1114000000', '서울특별시 중구', 60, 127, 126.0, 37.5636);
-- 서울특별시 용산구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1117000000', '서울특별시 용산구', 60, 126, 126.0, 37.5326);
-- 서울특별시 성동구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1120000000', '서울특별시 성동구', 61, 127, 127.0, 37.5637);
-- 서울특별시 광진구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1121500000', '서울특별시 광진구', 62, 126, 127.0, 37.5383);
-- 서울특별시 동대문구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1123000000', '서울특별시 동대문구', 61, 127, 127.0, 37.5743);
-- 서울특별시 중랑구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1126000000', '서울특별시 중랑구', 62, 128, 127.0, 37.6061);
-- 서울특별시 성북구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1129000000', '서울특별시 성북구', 61, 127, 127.0, 37.5873);
-- 서울특별시 강북구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1130500000', '서울특별시 강북구', 61, 128, 127.0, 37.6351);
-- 서울특별시 도봉구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1132000000', '서울특별시 도봉구', 61, 129, 127.0, 37.6548);
-- 서울특별시 노원구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1135000000', '서울특별시 노원구', 61, 129, 127.0, 37.6557);
-- 서울특별시 은평구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1138000000', '서울특별시 은평구', 59, 127, 126.0, 37.6040);
-- 서울특별시 서대문구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1141000000', '서울특별시 서대문구', 59, 127, 126.0, 37.5791);
-- 서울특별시 마포구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1144000000', '서울특별시 마포구', 59, 127, 126.0, 37.5663);
-- 서울특별시 양천구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1147000000', '서울특별시 양천구', 58, 126, 126.0, 37.5270);
-- 서울특별시 강서구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1150000000', '서울특별시 강서구', 58, 126, 126.0, 37.5586);
-- 서울특별시 구로구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1153000000', '서울특별시 구로구', 58, 125, 126.0, 37.4952);
-- 서울특별시 금천구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1154500000', '서울특별시 금천구', 59, 124, 126.0, 37.4592);
-- 서울특별시 영등포구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1156000000', '서울특별시 영등포구', 58, 126, 126.0, 37.5162);
-- 서울특별시 동작구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1159000000', '서울특별시 동작구', 59, 125, 126.0, 37.5110);
-- 서울특별시 관악구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1162000000', '서울특별시 관악구', 59, 125, 126.0, 37.4787);
-- 서울특별시 서초구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1165000000', '서울특별시 서초구', 61, 125, 127.0, 37.4836);
-- 서울특별시 강남구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1168000000', '서울특별시 강남구', 61, 126, 127.0, 37.5174);
-- 서울특별시 송파구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1171000000', '서울특별시 송파구', 62, 126, 127.0, 37.5144);
-- 서울특별시 강동구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor1174000000', '서울특별시 강동구', 62, 126, 127.0, 37.5303);

-- 부산
-- 부산광역시 중구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2611000000', '부산광역시 중구', 97, 74, 129.0, 35.1138);
-- 부산광역시 서구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2614000000', '부산광역시 서구', 97, 74, 129.0, 35.1031);
-- 부산광역시 동구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2617000000', '부산광역시 동구', 98, 75, 129.0, 35.0807);
-- 부산광역시 영도구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2620000000', '부산광역시 영도구', 98, 74, 129.0, 35.0917);
-- 부산광역시 부산진구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2623000000', '부산광역시 부산진구', 97, 75, 129.0, 35.1595);
-- 부산광역시 동래구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2626000000', '부산광역시 동래구', 98, 76, 129.0, 35.2470);
-- 부산광역시 남구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2629000000', '부산광역시 남구', 98, 75, 129.0, 35.1473);
-- 부산광역시 북구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2632000000', '부산광역시 북구', 96, 76, 128.0, 35.2092);
-- 부산광역시 해운대구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2635000000', '부산광역시 해운대구', 99, 75, 129.0, 35.1588);
-- 부산광역시 사하구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2638000000', '부산광역시 사하구', 96, 74, 128.0, 35.0995);
-- 부산광역시 금정구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2641000000', '부산광역시 금정구', 98, 77, 129.0, 35.2399);
-- 부산광역시 강서구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2644000000', '부산광역시 강서구', 96, 76, 128.0, 35.1693);
-- 부산광역시 연제구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2647000000', '부산광역시 연제구', 98, 76, 129.0, 35.1709);
-- 부산광역시 수영구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2650000000', '부산광역시 수영구', 99, 75, 129.0, 35.1582);
-- 부산광역시 사상구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2653000000', '부산광역시 사상구', 96, 75, 128.0, 35.1399);
-- 부산광역시 기장군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2671000000', '부산광역시 기장군', 100, 77, 129.0, 35.2391);

-- 대구
-- 대구광역시 중구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2711000000', '대구광역시 중구', 89, 90, 128.0, 35.8725);
-- 대구광역시 동구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2714000000', '대구광역시 동구', 90, 91, 128.0, 35.8806);
-- 대구광역시 서구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2717000000', '대구광역시 서구', 88, 90, 128.0, 35.8564);
-- 대구광역시 남구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2720000000', '대구광역시 남구', 89, 90, 128.0, 35.8340);
-- 대구광역시 북구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2723000000', '대구광역시 북구', 89, 91, 128.0, 35.8934);
-- 대구광역시 수성구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2726000000', '대구광역시 수성구', 89, 90, 128.0, 35.8560);
-- 대구광역시 달서구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2729000000', '대구광역시 달서구', 88, 90, 128.0, 35.8537);
-- 대구광역시 달성군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2771000000', '대구광역시 달성군', 86, 88, 128.0, 35.7441);
-- 대구광역시 군위군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2772000000', '대구광역시 군위군', 88, 99, 128.0, 35.8481);

-- 인천
-- 인천광역시 중구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2811000000', '인천광역시 중구', 54, 125, 126.0, 37.4639);
-- 인천광역시 동구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2814000000', '인천광역시 동구', 54, 125, 126.0, 37.4600);
-- 인천광역시 미추홀구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2817700000', '인천광역시 미추홀구', 54, 124, 126.0, 37.4440);
-- 인천광역시 연수구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2818500000', '인천광역시 연수구', 55, 123, 126.0, 37.4423);
-- 인천광역시 남동구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2820000000', '인천광역시 남동구', 56, 124, 126.0, 37.4505);
-- 인천광역시 부평구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2823700000', '인천광역시 부평구', 55, 125, 126.0, 37.4926);
-- 인천광역시 계양구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2824500000', '인천광역시 계양구', 56, 126, 126.0, 37.5387);
-- 인천광역시 서구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2826000000', '인천광역시 서구', 55, 126, 126.0, 37.5903);
-- 인천광역시 강화군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2871000000', '인천광역시 강화군', 51, 130, 126.0, 37.7383);
-- 인천광역시 옹진군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2872000000', '인천광역시 옹진군', 54, 124, 126.0, 37.7171);

-- 광주
-- 광주광역시 동구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2911000000', '광주광역시 동구', 60, 74, 126.0, 35.1530);
-- 광주광역시 서구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2914000000', '광주광역시 서구', 59, 74, 126.0, 35.1495);
-- 광주광역시 남구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2915500000', '광주광역시 남구', 59, 73, 126.0, 35.1460);
-- 광주광역시 북구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2917000000', '광주광역시 북구', 59, 75, 126.0, 35.1760);
-- 광주광역시 광산구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor2920000000', '광주광역시 광산구', 57, 74, 126.0, 35.2210);

-- 대전
-- 대전광역시 동구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor3011000000', '대전광역시 동구', 68, 100, 127.0, 36.3502);
-- 대전광역시 중구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor3014000000', '대전광역시 중구', 68, 100, 127.0, 36.3246);
-- 대전광역시 서구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor3017000000', '대전광역시 서구', 67, 100, 127.0, 36.3002);
-- 대전광역시 유성구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor3020000000', '대전광역시 유성구', 67, 101, 127.0, 36.3735);
-- 대전광역시 대덕구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor3023000000', '대전광역시 대덕구', 68, 100, 127.0, 36.3826);

-- 울산
-- 울산광역시 중구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor3111000000', '울산광역시 중구', 102, 84, 129.0, 35.5391);
-- 울산광역시 남구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor3114000000', '울산광역시 남구', 102, 84, 129.0, 35.5413);
-- 울산광역시 동구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor3117000000', '울산광역시 동구', 104, 83, 129.0, 35.4442);
-- 울산광역시 북구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor3120000000', '울산광역시 북구', 103, 85, 129.0, 35.5651);
-- 울산광역시 울주군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor3171000000', '울산광역시 울주군', 101, 84, 129.0, 35.5011);

-- 세종
-- 세종특별자치시 조치원읍
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor3611025000', '세종특별자치시 조치원읍', 66, 106, 127.0, 36.5232);
-- 세종특별자치시 연기면
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor3611031000', '세종특별자치시 연기면', 65, 105, 127.0, 36.5315);
-- 세종특별자치시 소정면
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor3611039000', '세종특별자치시 소정면', 63, 108, 127.0, 36.4756);
-- 세종특별자치시 세종시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor3611000000', '세종특별자치시 세종시', 66, 103, 127.0, 36.4823);


-- 경기
-- 경기도 수원시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4111100000', '경기도 수원시', 60, 121, 127.0, 37.2748);
-- 경기도 성남시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4113100000', '경기도 성남시', 63, 124, 127.0, 37.4484);
-- 경기도 의정부시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4115000000', '경기도 의정부시', 61, 130, 127.0, 37.7381);
-- 경기도 안양시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4117100000', '경기도 안양시', 59, 123, 126.0, 37.3925);
-- 경기도 부천시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4119200000', '경기도 부천시', 57, 125, 126.0, 37.4835);
-- 경기도 광명시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4121000000', '경기도 광명시', 58, 125, 126.0, 37.4762);
-- 경기도 평택시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4122000000', '경기도 평택시', 62, 114, 127.0, 37.0093);
-- 경기도 동두천시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4125000000', '경기도 동두천시', 61, 134, 127.0, 37.9012);
-- 경기도 안산시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4127100000', '경기도 안산시', 58, 121, 126.0, 37.3286);
-- 경기도 고양시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4128100000', '경기도 고양시', 57, 128, 126.0, 37.6763);
-- 경기도 과천시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4129000000', '경기도 과천시', 60, 124, 126.0, 37.4428);
-- 경기도 구리시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4131000000', '경기도 구리시', 62, 127, 127.0, 37.6135);
-- 경기도 남양주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4136000000', '경기도 남양주시', 64, 128, 127.0, 37.6435);
-- 경기도 오산시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4137000000', '경기도 오산시', 62, 118, 127.0, 37.1427);
-- 경기도 시흥시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4139000000', '경기도 시흥시', 57, 123, 126.0, 37.4089);
-- 경기도 군포시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4141000000', '경기도 군포시', 59, 122, 126.0, 37.3582);
-- 경기도 의왕시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4143000000', '경기도 의왕시', 60, 122, 126.0, 37.3373);
-- 경기도 하남시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4145000000', '경기도 하남시', 64, 126, 127.0, 37.5418);
-- 경기도 용인시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4146100000', '경기도 용인시', 64, 119, 127.0, 37.2417);
-- 경기도 파주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4148000000', '경기도 파주시', 56, 131, 126.0, 37.7481);
-- 경기도 이천시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4150000000', '경기도 이천시', 68, 121, 127.0, 37.2743);
-- 경기도 안성시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4155000000', '경기도 안성시', 65, 115, 127.0, 37.0089);
-- 경기도 김포시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4157000000', '경기도 김포시', 55, 128, 126.0, 37.6289);
-- 경기도 화성시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4159000000', '경기도 화성시', 57, 119, 126.0, 37.2573);
-- 경기도 광주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4161000000', '경기도 광주시', 65, 123, 127.0, 37.4135);
-- 경기도 양주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4163000000', '경기도 양주시', 61, 131, 127.0, 37.7485);
-- 경기도 포천시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4165000000', '경기도 포천시', 64, 134, 127.0, 37.8912);
-- 경기도 여주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4167000000', '경기도 여주시', 71, 121, 127.0, 37.2963);
-- 경기도 연천군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4180000000', '경기도 연천군', 61, 138, 127.0, 37.9028);
-- 경기도 가평군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4182000000', '경기도 가평군', 69, 133, 127.0, 37.8342);
-- 경기도 양평군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4183000000', '경기도 양평군', 69, 125, 127.0, 37.4718);

-- 충청북도
-- 충청북도 청주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4311100000', '충청북도 청주시', 69, 106, 127.0, 36.6423);
-- 충청북도 충주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4313000000', '충청북도 충주시', 76, 114, 127.0, 36.9783);
-- 충청북도 제천시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4315000000', '충청북도 제천시', 81, 118, 128.0, 37.1294);
-- 충청북도 보은군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4372000000', '충청북도 보은군', 73, 103, 127.0, 36.4842);
-- 충청북도 옥천군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4373000000', '충청북도 옥천군', 71, 99, 127.0, 36.3012);
-- 충청북도 영동군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4374000000', '충청북도 영동군', 74, 97, 127.0, 36.2292);
-- 충청북도 증평군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4374500000', '충청북도 증평군', 71, 110, 127.0, 36.6879);
-- 충청북도 진천군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4375000000', '충청북도 진천군', 68, 111, 127.0, 36.7553);
-- 충청북도 괴산군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4376000000', '충청북도 괴산군', 74, 111, 127.0, 36.7578);
-- 충청북도 음성군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4377000000', '충청북도 음성군', 72, 113, 127.0, 37.0178);
-- 충청북도 단양군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4380000000', '충청북도 단양군', 84, 115, 128.0, 37.1192);

-- 충청남도
-- 충청남도 천안시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4413100000', '충청남도 천안시', 63, 110, 127.0, 36.8036);
-- 충청남도 공주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4415000000', '충청남도 공주시', 63, 102, 127.0, 36.4879);
-- 충청남도 보령시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4418000000', '충청남도 보령시', 54, 100, 126.0, 36.3416);
-- 충청남도 아산시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4420000000', '충청남도 아산시', 60, 110, 127.0, 36.7882);
-- 충청남도 서산시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4421000000', '충청남도 서산시', 51, 110, 126.0, 36.7867);
-- 충청남도 논산시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4423000000', '충청남도 논산시', 62, 97, 127.0, 36.1775);
-- 충청남도 계룡시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4425000000', '충청남도 계룡시', 65, 99, 127.0, 36.2922);
-- 충청남도 당진시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4427000000', '충청남도 당진시', 54, 112, 126.0, 36.9703);
-- 충청남도 금산군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4471000000', '충청남도 금산군', 69, 95, 127.0, 36.1319);
-- 충청남도 부여군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4476000000', '충청남도 부여군', 59, 99, 126.0, 36.2938);
-- 충청남도 서천군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4477000000', '충청남도 서천군', 55, 94, 126.0, 36.0917);
-- 충청남도 청양군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4479000000', '충청남도 청양군', 57, 103, 126.0, 36.4482);
-- 충청남도 홍성군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4480000000', '충청남도 홍성군', 55, 106, 126.0, 36.6754);
-- 충청남도 예산군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4481000000', '충청남도 예산군', 58, 107, 126.0, 36.7406);
-- 충청남도 태안군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4482500000', '충청남도 태안군', 48, 109, 126.0, 36.7527);


-- 전라남도
-- 전라남도 목포시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4611000000', '전라남도 목포시', 50, 67, 126.0, 34.8111);
-- 전라남도 여수시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4613000000', '전라남도 여수시', 73, 66, 127.0, 34.7603);
-- 전라남도 순천시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4615000000', '전라남도 순천시', 70, 70, 127.0, 34.9487);
-- 전라남도 나주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4617000000', '전라남도 나주시', 56, 71, 126.0, 35.0202);
-- 전라남도 광양시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4623000000', '전라남도 광양시', 73, 70, 127.0, 34.9307);
-- 전라남도 담양군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4671000000', '전라남도 담양군', 61, 78, 126.0, 35.3451);
-- 전라남도 곡성군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4672000000', '전라남도 곡성군', 66, 77, 127.0, 35.2053);
-- 전라남도 구례군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4673000000', '전라남도 구례군', 69, 75, 127.0, 35.1227);
-- 전라남도 고흥군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4677000000', '전라남도 고흥군', 66, 62, 127.0, 34.5883);
-- 전라남도 보성군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4678000000', '전라남도 보성군', 62, 66, 127.0, 34.7527);
-- 전라남도 화순군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4679000000', '전라남도 화순군', 61, 72, 126.0, 35.0355);
-- 전라남도 장흥군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4680000000', '전라남도 장흥군', 59, 64, 126.0, 34.6425);
-- 전라남도 강진군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4681000000', '전라남도 강진군', 57, 63, 126.0, 34.6501);
-- 전라남도 해남군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4682000000', '전라남도 해남군', 54, 61, 126.0, 34.5796);
-- 전라남도 영암군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4683000000', '전라남도 영암군', 56, 66, 126.0, 34.7228);
-- 전라남도 무안군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4684000000', '전라남도 무안군', 52, 71, 126.0, 34.9713);
-- 전라남도 함평군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4686000000', '전라남도 함평군', 52, 72, 126.0, 34.8252);
-- 전라남도 영광군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4687000000', '전라남도 영광군', 52, 77, 126.0, 35.2707);
-- 전라남도 장성군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4688000000', '전라남도 장성군', 57, 77, 126.0, 35.2328);
-- 전라남도 완도군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4689000000', '전라남도 완도군', 57, 56, 126.0, 34.3457);
-- 전라남도 진도군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4690000000', '전라남도 진도군', 48, 59, 126.0, 34.4874);
-- 전라남도 신안군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4691000000', '전라남도 신안군', 50, 66, 126.0, 34.8540);


-- 전라북도
-- 전북특별자치도 전주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5211100000', '전북특별자치도 전주시', 63, 89, 127.0, 35.8189);
-- 전북특별자치도 군산시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5213000000', '전북특별자치도 군산시', 56, 92, 126.0, 35.7151);
-- 전북특별자치도 익산시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5214000000', '전북특별자치도 익산시', 60, 91, 126.0, 35.9467);
-- 전북특별자치도 정읍시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5218000000', '전북특별자치도 정읍시', 58, 83, 126.0, 35.5994);
-- 전북특별자치도 남원시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5219000000', '전북특별자치도 남원시', 68, 80, 127.0, 35.3803);
-- 전북특별자치도 김제시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5221000000', '전북특별자치도 김제시', 59, 88, 126.0, 35.7795);
-- 전북특별자치도 완주군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5271000000', '전북특별자치도 완주군', 63, 89, 127.0, 35.3908);
-- 전북특별자치도 진안군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5272000000', '전북특별자치도 진안군', 68, 88, 127.0, 35.6700);
-- 전북특별자치도 무주군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5273000000', '전북특별자치도 무주군', 72, 93, 127.0, 35.8780);
-- 전북특별자치도 장수군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5274000000', '전북특별자치도 장수군', 70, 85, 127.0, 35.5540);
-- 전북특별자치도 임실군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5275000000', '전북특별자치도 임실군', 66, 84, 127.0, 35.5807);
-- 전북특별자치도 순창군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5277000000', '전북특별자치도 순창군', 63, 79, 127.0, 35.4422);
-- 전북특별자치도 고창군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5279000000', '전북특별자치도 고창군', 56, 80, 126.0, 35.3597);
-- 전북특별자치도 부안군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5280000000', '전북특별자치도 부안군', 56, 87, 126.0, 35.7233);


-- 경상북도
-- 경상북도 포항시 남구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4711100000', '경상북도 포항시', 102, 94, 129.0, 36.0227);
-- 경상북도 경주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4713000000', '경상북도 경주시', 100, 91, 129.0, 35.8505);
-- 경상북도 김천시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4715000000', '경상북도 김천시', 80, 96, 128.0, 36.1427);
-- 경상북도 안동시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4717000000', '경상북도 안동시', 91, 106, 128.0, 36.5664);
-- 경상북도 구미시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4719000000', '경상북도 구미시', 84, 96, 128.0, 36.1163);
-- 경상북도 영주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4721000000', '경상북도 영주시', 89, 111, 128.0, 36.8554);
-- 경상북도 영천시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4723000000', '경상북도 영천시', 95, 93, 128.0, 35.9543);
-- 경상북도 상주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4725000000', '경상북도 상주시', 81, 102, 128.0, 36.4344);
-- 경상북도 문경시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4728000000', '경상북도 문경시', 81, 106, 128.0, 36.5977);
-- 경상북도 경산시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4729000000', '경상북도 경산시', 91, 90, 128.0, 35.7997);
-- 경상북도 의성군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4773000000', '경상북도 의성군', 90, 101, 128.0, 36.2001);
-- 경상북도 청송군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4775000000', '경상북도 청송군', 96, 103, 129.0, 36.3639);
-- 경상북도 영양군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4776000000', '경상북도 영양군', 97, 108, 129.0, 36.3197);
-- 경상북도 영덕군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4777000000', '경상북도 영덕군', 102, 103, 129.0, 36.4442);
-- 경상북도 청도군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4782000000', '경상북도 청도군', 91, 86, 128.0, 35.6901);
-- 경상북도 고령군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4783000000', '경상북도 고령군', 83, 87, 128.0, 35.5732);
-- 경상북도 성주군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4784000000', '경상북도 성주군', 83, 91, 128.0, 35.7969);
-- 경상북도 칠곡군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4785000000', '경상북도 칠곡군', 85, 93, 128.0, 35.9883);
-- 경상북도 예천군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4790000000', '경상북도 예천군', 86, 107, 128.0, 36.6138);
-- 경상북도 봉화군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4792000000', '경상북도 봉화군', 90, 113, 128.0, 36.9023);
-- 경상북도 울진군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4793000000', '경상북도 울진군', 102, 115, 129.0, 36.9913);
-- 경상북도 울릉군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4794000000', '경상북도 울릉군', 127, 127, 130.0, 37.4667);

-- 경상남도
-- 경상남도 마산시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4812500000', '경상남도 마산시', 89, 76, 128.0, 35.2100);
-- 경상남도 창원시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4813000000', '경상남도 창원시', 88, 78, 128.0, 35.2280);
-- 경상남도 진주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4815000000', '경상남도 진주시', 90, 83, 128.0, 35.1810);
-- 경상남도 김해시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4817000000', '경상남도 김해시', 89, 80, 128.0, 35.2323);
-- 경상남도 밀양시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4819000000', '경상남도 밀양시', 91, 82, 128.0, 35.4855);
-- 경상남도 통영시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4820000000', '경상남도 통영시', 91, 70, 128.0, 34.8491);
-- 경상남도 사천시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4821000000', '경상남도 사천시', 93, 75, 128.0, 34.9701);
-- 경상남도 진해시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4823000000', '경상남도 진해시', 87, 77, 128.0, 35.1075);
-- 경상남도 거제시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4825000000', '경상남도 거제시', 94, 70, 128.0, 34.8813);
-- 경상남도 양산시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4826000000', '경상남도 양산시', 90, 79, 128.0, 35.3384);
-- 경상남도 하동군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4871000000', '경상남도 하동군', 95, 79, 128.0, 35.0997);
-- 경상남도 거창군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4872000000', '경상남도 거창군', 87, 84, 128.0, 35.5874);
-- 경상남도 합천군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4873000000', '경상남도 합천군', 88, 89, 128.0, 35.5637);
-- 경상남도 창녕군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4874000000', '경상남도 창녕군', 92, 88, 128.0, 35.2902);
-- 경상남도 함안군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4875000000', '경상남도 함안군', 90, 85, 128.0, 35.1983);
-- 경상남도 산청군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4876000000', '경상남도 산청군', 94, 85, 128.0, 35.3289);
-- 경상남도 의령군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4877000000', '경상남도 의령군', 90, 91, 128.0, 35.3450);
-- 경상남도 남해군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4878000000', '경상남도 남해군', 93, 68, 128.0, 34.8445);
-- 경상남도 창원시 의창구
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor4812000000', '경상남도 창원시 의창구', 88, 77, 128.0, 35.2364);


-- 제주도
-- 제주특별자치도 제주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5011000000', '제주특별자치도 제주시', 53, 38, 126.0, 33.4996);
-- 제주특별자치도 서귀포시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5013000000', '제주특별자치도 서귀포시', 52, 33, 126.0, 33.2556);

-- 강원도
-- 강원특별자치도 춘천시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5111000000', '강원특별자치도 춘천시', 73, 134, 127.0, 37.8836);
-- 강원특별자치도 원주시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5113000000', '강원특별자치도 원주시', 76, 122, 127.0, 37.3439);
-- 강원특별자치도 강릉시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5115000000', '강원특별자치도 강릉시', 92, 131, 128.0, 37.7519);
-- 강원특별자치도 동해시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5117000000', '강원특별자치도 동해시', 97, 127, 129.0, 37.5207);
-- 강원특별자치도 태백시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5119000000', '강원특별자치도 태백시', 95, 119, 128.0, 37.1547);
-- 강원특별자치도 속초시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5121000000', '강원특별자치도 속초시', 87, 141, 128.0, 38.2073);
-- 강원특별자치도 삼척시
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5123000000', '강원특별자치도 삼척시', 98, 125, 129.0, 38.4285);
-- 강원특별자치도 홍천군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5172000000', '강원특별자치도 홍천군', 75, 130, 127.0, 37.6556);
-- 강원특별자치도 횡성군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5173000000', '강원특별자치도 횡성군', 77, 125, 127.0, 37.4533);
-- 강원특별자치도 영월군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5175000000', '강원특별자치도 영월군', 86, 119, 128.0, 37.1925);
-- 강원특별자치도 평창군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5176000000', '강원특별자치도 평창군', 84, 123, 128.0, 37.4375);
-- 강원특별자치도 정선군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5177000000', '강원특별자치도 정선군', 89, 123, 128.0, 37.4608);
-- 강원특별자치도 철원군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5178000000', '강원특별자치도 철원군', 65, 139, 127.0, 38.2000);
-- 강원특별자치도 화천군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5179000000', '강원특별자치도 화천군', 72, 139, 127.0, 38.1180);
-- 강원특별자치도 양구군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5180000000', '강원특별자치도 양구군', 77, 139, 127.0, 38.1150);
-- 강원특별자치도 인제군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5181000000', '강원특별자치도 인제군', 80, 138, 128.0, 38.1333);
-- 강원특별자치도 고성군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5182000000', '강원특별자치도 고성군', 85, 145, 128.0, 38.3925);
-- 강원특별자치도 양양군
INSERT INTO weather_coordinate (kor_code, area_name, grid_x, grid_y, longitude, latitude)
VALUES ('kor5183000000', '강원특별자치도 양양군', 88, 138, 128.0, 38.0722);


commit;

select * from weather_coordinate;


