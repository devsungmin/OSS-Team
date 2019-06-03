 <%@ page language="java" contentType="text/html; charset=UTF-8"

    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<!-- 뷰포트 -->

<meta name="viewport" content="width=device-width" initial-scale="1">
<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=krqrfbpm8q"></script>
<!-- 스타일시트 참조  -->

<link rel="stylesheet" href="css/bootstrap.min.css">

<title>내 주변 대피소 찾기</title>



</head>

<body>
<%

		//로긴한사람이라면	 userID라는 변수에 해당 아이디가 담기고 그렇지 않으면 null값

		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
	%>
 <!-- 네비게이션  -->

 <nav class="navbar navbar-default">

		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="bs-example-navbar-collapse-1"
				aria-expaned="false">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">내 주변 대피소 찾기</a>
		</div>
		<div class="collapse navbar-collapse"
			id="#bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active"><a href="main.jsp">메인</a></li>
				<li><a href="oss.jsp">게시판</a></li>
			</ul>
			<%
				//라긴안된경우
				if (userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>

 <!-- 메인폼 -->
<div class="container">
  <div class="col-lg-4"></div>
  <div class="col-lg-4">
  <!-- 지도 -->
	<div id="map" style="width:100%;height:400px;"></div>
   	<script>
   	//맵 객체 생성
   	var mapContainer = document.getElementById('map'),
    mapOption = { 
        center: new naver.maps.LatLng(36.8092096, 127.1460138), // 지도의 중심좌표 -> 천안역
        zoom: 10 
    };
	var map = new naver.maps.Map(mapContainer, mapOption);
	// 대피소 위치
   	var positions = [
   		{
   			content:'<div><h4>광성장여관(지하주차장)</h4><br>충청남도 천안시 동남구 원성동 517번지 10호</div>',
   	        latlng:new naver.maps.LatLng(36.806103, 127.1612705)
   		},
   		{
   			content:'<div><h4>정원맨숀(지하주차장)</h4><br>충청남도 천안시 동남구 원성동 524번지 2호</div>',
   	        latlng:new naver.maps.LatLng(36.805786, 127.1629145)
   		},
   		{
   			content:'<div><h4>다가동 한화꿈에그린아파트(지하주차장)</h4><br>충청남도 천안시 동남구 다가동 444번지 3호</div>',
   	        latlng:new naver.maps.LatLng(36.797281, 127.137717)
   		},
   		{
   			content:'<div><h4>포스코더샵오피스텔(지하주차장)</h4><br>충청남도 천안시 동남구 만남로 9 (신부동 더샵오피스텔)</div>',
   	        latlng:new naver.maps.LatLng(36.819139, 127.153003)
   		},
   		{
   			content:'<div><h4>CGV(지하주차장)</h4><br>충청남도 천안시 동남구 명동길 47 (대흥동 CGV)</div>',
   	        latlng:new naver.maps.LatLng(36.807686, 127.148381)
   		},
   		{
   			content:'<div><h4>농협은행 대흥동지점 앞 지하상가주차장</h4><br>충청남도 천안시 동남구 명동길 (문화동)</div>',
   	        latlng:new naver.maps.LatLng(36.808458, 127.149817)
   		},
   		{
   			content:'<div><h4>신도브래뉴2차아파트(지하주차장)</h4><br>충청남도 천안시 동남구 목천읍 목천안터2길 19 (신도브래뉴2차아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.777781, 127.210667)
   		},
   		{
   			content:'<div><h4>부영2단지아파트(지하주차장)</h4><br>충청남도 천안시 동남구 목천읍 삼성5길 41 (원앙마을 부영아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.761769, 127.176989)
   		},
   		{
   			content:'<div><h4>부영1단지아파트(지하주차장)</h4><br>충청남도 천안시 동남구 목천읍 삼성5길 42 (부영아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.758992, 127.178917)
   		},
   		{
   			content:'<div><h4>대흥동지하상가</h4><br>충청남도 천안시 동남구 버들로 지하 2 (대흥동 지하상가)</div>',
   	        latlng:new naver.maps.LatLng(36.809347, 127.148194)
   		},
   		{
   			content:'<div><h4>봉명청솔3차아파트(지하주차장)</h4><br>충청남도 천안시 동남구 봉서8길 13 (봉명동 청솔3차아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.810894, 127.132358)
   		},
   		{
   			content:'<div><h4>신동아아파트(지하주차장)</h4><br>충청남도 천안시 동남구 새말4길 5 (신방동 신동아아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.793931, 127.131853)
   		},
   		{
   			content:'<div><h4>향촌현대아파트(지하주차장)</h4><br>충청남도 천안시 동남구 서부대로 226-11 (신방동 향촌현대아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.789247, 127.130083)
   		},
   		{
   			content:'<div><h4>한라동백2차아파트(지하주차장)</h4><br>충청남도 천안시 동남구 서부대로 226-12 (신방동 한라동백2차아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.787108, 127.129922)
   		},
   		{
   			content:'<div><h4>두레현대2단지아파트(지하주차장)</h4><br>충청남도 천안시 동남구 서부대로 252 (신방동 신방동두레현대아파트2단지)</div>',
   	        latlng:new naver.maps.LatLng(36.791086, 127.130167)
   		},
   		{
   			content:'<div><h4>초원그린아파트(지하주차장)</h4><br>충청남도 천안시 동남구 신촌4로 16 (신방동 초원아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.787306, 127.126369)
   		},
   		{
   			content:'<div><h4>초원라이프아파트(지하주차장)</h4><br>충청남도 천안시 동남구 원성5길 17 (원성동 초원라이프타운)</div>',
   	        latlng:new naver.maps.LatLng(36.807956, 127.162289)
   		},
   		{
   			content:'<div><h4>성지새말1단지아파트(지하주차장)</h4><br>충청남도 천안시 동남구 일봉로 17 (신방동 성지새말아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.794117, 127.130117)
   		},
   		{
   			content:'<div><h4>성지새말2단지아파트(지하주차장)</h4><br>충청남도 천안시 동남구 일봉로 20 (신방동 성지새말아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.792414, 127.130644)
   		},
   		{
   			content:'<div><h4>두레현대1단지아파트(지하주차장)</h4><br>충청남도 천안시 동남구 일봉로 34 (신방동 두레현대아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.7925948, 127.132131)
   		},
   		{
   			content:'<div><h4>동일하이빌아파트1단지아파트(1 4 5 지하주차장)</h4><br>충청남도 천안시 동남구 일봉로 71 (용곡동 동일하이빌1단지아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.791956, 127.137417)
   		},
   		{
   			content:'<div><h4>신성미소지움아파트(지하주차장)</h4><br>충청남도 천안시 동남구 천안대로 483-8 (구성동 신성미소지움아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.792844, 127.1637275)
   		},
   		{
   			content:'<div><h4>방죽안휴먼시아아파트(지하주차장)</h4><br>충청남도 천안시 동남구 천안천8길 45 (신부동 방죽안휴먼시아아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.821683, 127.155067)
   		},
   		{
   			content:'<div><h4>청당벽산블루밍아파트(지하주차장)</h4><br>충청남도 천안시 동남구 청당2길 118 (청당동 청당벽산블루밍아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.779283, 127.156197)
   		},
   		{
   			content:'<div><h4>청솔엘지에스케이아파트(지하주차장)</h4><br>충청남도 천안시 동남구 청수로 98 (청수동 청솔LG아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.792014, 127.157775)
   		},
   		{
   			content:'<div><h4>우성VIP아파트(지하주차장)</h4><br>충청남도 천안시 동남구 충무로 455-3 (원성동 우성VIP아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.798772, 127.155453)
   		},
   		{
   			content:'<div><h4>충남근로자복지회관(지하주차장)</h4><br>충청남도 천안시 동남구 충무로 457 (원성동 충청남도근로자복지회관)</div>',
   	        latlng:new naver.maps.LatLng(36.798811, 127.156183)
   		},
   		{
   			content:'<div><h4>교보생명(지하주차장)</h4><br>충청남도 천안시 동남구 충절로 138 (원성동 교보생명)</div>',
   	        latlng:new naver.maps.LatLng(36.806753, 127.158417)
   		},
   		{
   			content:'<div><h4>원성극동아파트(101동 지하)</h4><br>충청남도 천안시 동남구 충절로 190 (원성동 원성극동아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.802492, 127.158642)
   		},
   		{
   			content:'<div><h4>천안동부새마을금고(지하주차장)</h4><br>충청남도 천안시 동남구 충절로 196 (원성동 천안동부새마을금고)</div>',
   	        latlng:new naver.maps.LatLng(36.801347, 127.158808)
   		},
   		{
   			content:'<div><h4>파고다아파트(지하주차장)</h4><br>충청남도 천안시 동남구 큰시장길 37 (영성동 파고다주상복합아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.802231, 127.150972)
   		},
   		{
   			content:'<div><h4>대림한들아파트(지하주차장)</h4><br>충청남도 천안시 동남구 터미널9길 59 (신부동 대림한들아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.823794, 127.158789)
   		},
   		{
   			content:'<div><h4>청수현대아파트(지하주차장)</h4><br>충청남도 천안시 동남구 풍세로 1010-31 (청수동 청수현대아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.797417, 127.153894)
   		},
   		{
   			content:'<div><h4>e편한세상스마일시티아파트(지하주차장)</h4><br>충청남도 천안시 서북구 3공단6로 85-27 (차암동 e편한세상스마일시티)</div>',
   	        latlng:new naver.maps.LatLng(36.843828, 127.103606)
   		},
   		{
   			content:'<div><h4>불당한화꿈에그린아파트(지하주차장)</h4><br>충청남도 천안시 서북구 광장로 260 (불당동)</div>',
   	        latlng:new naver.maps.LatLng(36.801042, 127.113497)
   		},
   		{
   			content:'<div><h4>e편한세상두정2차아파트(지하주차장)</h4><br>충청남도 천안시 서북구 노태산로 145 (두정동)</div>',
   	        latlng:new naver.maps.LatLng(36.838003, 127.129653)
   		},
   		{
   			content:'<div><h4>세광엔리치빌3단지아파트(지하주차장)</h4><br>충청남도 천안시 서북구 늘푸른1길 29 (두정동)</div>',
   	        latlng:new naver.maps.LatLng(36.828192, 127.128383)
   		},
   		{
   			content:'<div><h4>서해그랑블아파트(지하주차장)</h4><br>충청남도 천안시 서북구 늘푸른1길 32 (두정동)</div>',
   	        latlng:new naver.maps.LatLng(36.828169, 127.130203)
   		},
   		{
   			content:'<div><h4>e편한세상스마일시티아파트(지하주차장)</h4><br>충청남도 천안시 서북구 3공단6로 85-27 (차암동 e편한세상스마일시티)</div>',
   	        latlng:new naver.maps.LatLng(36.843828, 127.103606)
   		},
   		{
   			content:'<div><h4>대우푸르지오4차아파트(지하주차장)</h4><br>충청남도 천안시 서북구 늘푸른1길 50 (두정동)</div>',
   	        latlng:new naver.maps.LatLng(36.829519, 127.130208)
   		},
   		{
   			content:'<div><h4>극동늘푸른아파트(지하주차장)</h4><br>충청남도 천안시 서북구 늘푸른6길 42 (두정동)</div>',
   	        latlng:new naver.maps.LatLng(36.828117, 127.131911)
   		},
   		{
   			content:'<div><h4>선경아파트(지하주차장)</h4><br>충청남도 천안시 서북구 도원2길 39 (성정동 선경아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.822097, 127.133569)
   		},
   		{
   			content:'<div><h4>충남타워(지하주차장)</h4><br>충청남도 천안시 서북구 동서대로 163 (성정동 충남타워)</div>',
   	        latlng:new naver.maps.LatLng(36.825911, 127.141306)
   		},
   		{
   			content:'<div><h4>대우푸르지오5차아파트(지하주차장)</h4><br>충청남도 천안시 서북구 두정고1길 9 (두정동)</div>',
   	        latlng:new naver.maps.LatLng(36.834742, 127.128717)
   		},
   		{
   			content:'<div><h4>우성아파트(지하주차장)</h4><br>충청남도 천안시 서북구 두정고7길 36 (두정동)</div>',
   	        latlng:new naver.maps.LatLng(36.836475, 127.132467)
   		},
   		{
   			content:'<div><h4>대주파크빌아파트(지하주차장)</h4><br>충청남도 천안시 서북구 두정고7길 9 (두정동)</div>',
   	        latlng:new naver.maps.LatLng(36.836542, 127.129978)
   		},
   		{
   			content:'<div><h4>두정한성2차아파트(지하주차장)</h4><br>충청남도 천안시 서북구 두정고8길 24 (두정동)</div>',
   	        latlng:new naver.maps.LatLng(36.837636, 127.133356)
   		},
   	]
	
   	for (var i = 0; i < positions.length; i++) {
   	    // 대피소 위치 마커 표시
   	    var marker = new naver.maps.Marker({
   	        map: map, // 마커를 표시할 지도
   	        position: positions[i].latlng // 마커의 위치
   	    });

   	    // 대피소 정보 표시
   	     var infowindow = new naver.maps.InfoWindow({
   	        content: positions[i].content
   	    });
   	    // 마커 클릭시 표시되는 정보창 
   	    var event = new naver.maps.Event.addListener(marker, "click", function(e) {
    		if (infowindow.getMap()) {
        		infowindow.close();
    		} else {
        		infowindow.open(map, marker);
    		}
   		});
   	}
   	</script>
   
 </div>
</div>
 <form method="post" action="result.jsp">
<div class="container">
	<div class="col-lg-4"></div>
	<div class="col-lg-4">
	<input type="submit" class="btn btn-primary form-control" value="대피소 찾기">
	</div>
	
	</div>
</form>
 

 

 <!-- 애니매이션 담당 JQUERY -->

 <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script> 

 <!-- 부트스트랩 JS  -->

 <script src="js/bootstrap.js"></script>

 

</body>

</html>