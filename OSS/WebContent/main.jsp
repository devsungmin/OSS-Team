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
   	        latlng:new naver.maps.LatLng(36.808458, 127.127.149817)
   		},
   		{
   			content:'<div><h4>신도브래뉴2차아파트(지하주차장)</h4><br>충청남도 천안시 동남구 목천읍 목천안터2길 19 (신도브래뉴2차아파트)</div>',
   	        latlng:new naver.maps.LatLng(36.819139, 127.153003)
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
   		}
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