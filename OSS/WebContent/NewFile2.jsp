﻿ <%@ page language="java" contentType="text/html; charset=UTF-8"

    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<!-- 뷰포트 -->

<meta name="viewport" content="width=device-width" initial-scale="1">
 <script src="https://api2.sktelecom.com/tmap/js?version=1&format=javascript&appKey=d9c9c610-76ec-4a74-b6b5-ef90cb8c2985"></script>
<!-- 스타일시트 참조  -->

<link rel="stylesheet" href="css/bootstrap.min.css">

<title>내 주변 대피소 찾기</title>



</head>

<body onload="initTmap()">
<%
		int a=0;
		//로긴한사람이라면	 userID라는 변수에 해당 아이디가 담기고 그렇지 않으면 null값

		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
			a=10;
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
			<a class="navbar-brand" href="NewFile2.jsp">내 주변 대피소 찾기</a>
		</div>
		<div class="collapse navbar-collapse"
			id="#bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active"><a href="NewFile2.jsp">메인</a></li>
				<li><a href="list.jsp">게시판</a></li>
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
<div class="row">


  <!-- 지도 -->
  <div class="col-lg-6">
	<div id="map_div">
	<script>
	var popup, markerLayer;
	var lonlat, size, offset, icon;
	var selectMarker, selectPopup;
	var arrMarkerPopup = [];
	var map, markerA, markerB, marker
	var markerLayer_s = new Tmap.Layer.Markers("start");// 마커 레이어 생성
	var markerLayer_e = new Tmap.Layer.Markers("end");
	var markerLayer = new Tmap.Layer.Markers();
	var routeLayer = new Tmap.Layer.Vector("route");
	routeLayer.style ={
	    fillColor:"#FF0000",
	    fillOpacity:0.2,
	    strokeColor: "#FF0000",
	    strokeWidth: 3,
	    strokeDashstyle: "solid",
	    pointRadius: 2,
	    title: "this is a red line"	
	};
	var lonlat = new Tmap.LonLat(36.8092096,127.1460138).transform("EPSG:4326", "EPSG:3857");//좌표 설정
	var geolocation = navigator.geolocation;

	var icon_s = icon("s");
	var icon_e = icon("e");

	var start_x;
	var start_y;
	var end_x;
	var end_y;

	var input_s = false;
	var input_e = false;
	// 마커와 팝업을 세팅합니다.
	function MarkerPopup(marker, popup) {
		this.marker = marker;
		this.popup = popup;
	}
	// 홈페이지 로딩과 동시에 맵을 호출할 함수
	function initTmap(){
	    map = new Tmap.Map({
	        div:'map_div',
	        width : "40rem",
	        height : "40rem",
	    });

	    map.events.register("click", map, onClick);
	    
	    map.addLayer(markerLayer_s); // 맵에 마커레이어 추가
	    map.addLayer(markerLayer_e);
	    map.addLayer(markerLayer);

	    // HTML5의 geolocation으로 사용할 수 있는지 확인합니다. 
	    // 현재 위치 정보를 얻어오는 메서드이다. 사용자가 허용을 할 경우 실행된다.
	        // GeoLocation을 이용해서 접속 위치를 얻어옵니다.
	        if (geolocation)    geoLocation("s");
	      //맵 객체 생성
	       		markerLayer = new Tmap.Layer.Markers();//마커 레이어 생성
	    		map.addLayer(markerLayer);//map에 마커 레이어 추가
	    		
	    		var size = new Tmap.Size(24, 38);//아이콘 크기
	    		var offset = new Tmap.Pixel(-(size.w / 2), -(size.h));//아이콘 중심점
	    	// 대피소 위치
	    		var positions = [
	       		{
	    			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>광성장여관(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('광성장여관(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.1612705,36.806103).transform("EPSG:4326", "EPSG:3857")//좌표 지정
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>정원맨숀(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('정원맨숀(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.1629145,36.805786).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>다가동 한화꿈에그린아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('다가동 한화꿈에그린아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.137717,36.797281).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>포스코더샵오피스텔(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('포스코더샵오피스텔(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.153003,36.819139).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>CGV(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('CGV(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.148381,36.807686).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>농협은행 대흥동지점 앞 지하상가주차장"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('농협은행 대흥동지점 앞 지하상가주차장')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.149817,36.808458).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>신도브래뉴2차아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('신도브래뉴2차아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.210667,36.777781).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>부영2단지아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('부영2단지아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.176989,36.761769).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>부영1단지아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('부영1단지아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.178917,36.758992).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>대흥동지하상가"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('대흥동지하상가')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.148194,36.809347).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>봉명청솔3차아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('봉명청솔3차아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.132358,36.810894).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>신동아아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('신동아아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.131853,36.793931).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>향촌현대아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('향촌현대아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.130083,36.789247).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>한라동백2차아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('한라동백2차아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.129922,36.787108).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>두레현대2단지아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('두레현대2단지아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.130167,36.791086).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>초원그린아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('초원그린아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.126369,36.787306).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>초원라이프아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('초원라이프아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.162289,36.807956).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>성지새말1단지아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('성지새말1단지아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.130117,36.794117).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>성지새말2단지아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('성지새말2단지아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.130644,36.792414).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>두레현대1단지아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('두레현대1단지아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.132131,36.7925948).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>동일하이빌아파트1단지아파트(1 4 5 지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('동일하이빌아파트1단지아파트(1 4 5 지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.137417,36.791956).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>신성미소지움아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('신성미소지움아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.1637275,36.792844).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>방죽안휴먼시아아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('방죽안휴먼시아아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.155067,36.821683).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>청당벽산블루밍아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('청당벽산블루밍아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.156197,36.779283).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>청솔엘지에스케이아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('청솔엘지에스케이아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.157775,36.792014).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>우성VIP아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('우성VIP아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.155453,36.798772).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>충남근로자복지회관(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('충남근로자복지회관(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.156183,36.798811).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>교보생명(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('교보생명(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.158417,36.806753).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>원성극동아파트(101동 지하)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('원성극동아파트(101동 지하)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.158642,36.802492).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>천안동부새마을금고(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('천안동부새마을금고(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.158808,36.801347).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>파고다아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('파고다아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.150972,36.802231).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>대림한들아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('대림한들아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.158789,36.823794).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>청수현대아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('청수현대아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.153894,36.797417).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>e편한세상스마일시티아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('e편한세상스마일시티아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.103606,36.843828).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>불당한화꿈에그린아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('불당한화꿈에그린아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.113497,36.801042).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>e편한세상두정2차아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('e편한세상두정2차아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.129653,36.838003).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>세광엔리치빌3단지아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('세광엔리치빌3단지아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.128383,36.828192).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>서해그랑블아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('서해그랑블아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.130203,36.828169).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>대우푸르지오4차아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('대우푸르지오4차아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.103606,36.843828).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>극동늘푸른아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('극동늘푸른아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.130208,36.829519).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>선경아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('선경아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.131911,36.828117).transform("EPSG:4326", "EPSG:3857")
			},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>광성장여관(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('광성장여관(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.133569,36.822097).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>충남타워(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('충남타워(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
			lonlat: new Tmap.LonLat(127.133569,36.822097).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>대우푸르지오5차아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('대우푸르지오5차아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
			lonlat: new Tmap.LonLat(127.141306,36.825911).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>우성아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('우성아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
			lonlat: new Tmap.LonLat(127.128717,36.834742).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>대주파크빌아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('대주파크빌아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
			lonlat: new Tmap.LonLat(127.132467,36.836475).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>두정한성2차아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('두정한성2차아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
			lonlat: new Tmap.LonLat(127.129978,36.836542).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>두정역푸르지오아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('두정역푸르지오아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
			lonlat: new Tmap.LonLat(127.133356,36.837636).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>두정우남아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('두정우남아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
			lonlat: new Tmap.LonLat(127.150333,36.833808).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>경남아너스빌아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('경남아너스빌아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
			lonlat: new Tmap.LonLat(127.146856,36.838225).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>두정e편한세상아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('두정e편한세상아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
			lonlat: new Tmap.LonLat(127.139614,36.838297).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>대우타워아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('대우타워아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.140897,36.834906).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>광명아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('광명아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.131489,36.806164).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>주공그린빌11단지3차아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('주공그린빌11단지3차아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.128358,36.801769).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>천안시청(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('천안시청(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.118692,36.819844).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>벽산블루밍1차아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('벽산블루밍1차아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.1136868,36.815658).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>일성2차버들아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('일성2차버들아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.114092,36.824992).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>불당호반리젠시빌아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('불당호반리젠시빌아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.131283,36.809864).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>주공9단지아파트(404동과 407동 사이 지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('주공9단지아파트(404동과 407동 사이 지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.116903,36.805997).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>두정한성3차필하우스아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('두정한성3차필하우스아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.122431,36.805711).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>주공8단지아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('주공8단지아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.147069,36.8342929).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>한성스위트빌아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('한성스위트빌아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.144525,36.836158).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>계룡리슈빌아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('계룡리슈빌아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.134392,36.835994).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>불당한성필하우스아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('불당한성필하우스아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.137083,36.838308).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>대원칸타빌아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('대원칸타빌아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.1159951,36.803319).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>불당아이파크아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('불당아이파크아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.109253,36.808597).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>화승아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('화승아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.141703,36.821375).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>반석의원(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('반석의원(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.141339,36.822208).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>성거벽산아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('성거벽산아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.159411,36.878686).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>삼환나우빌아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('삼환나우빌아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.157128,36.877253).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>성거백승아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('성거백승아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.203086,36.873122).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>대우성촌프라자아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('대우성촌프라자아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.138808,36.817831).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>대우푸르지오3차아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('대우푸르지오3차아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.142897,36.838267).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>후생빌딩(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('후생빌딩(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.1390834,36.813547).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>현대한솔아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('현대한솔아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.136361,36.918017).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>성환e편한세상아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('성환e편한세상아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.132933,36.901603).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>삼풍아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('삼풍아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.130997,36.912333).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>성환부영2차아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('성환부영2차아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.1345145,36.903972).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>대동다숲아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('대동다숲아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.1114498,36.805861).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>불당동일하이빌아파트(지하2층 주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('불당동일하이빌아파트(지하2층 주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.112917,36.807978).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>신당코아루아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('신당코아루아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.159347,36.853336).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>라이프타운아파트(102 103동과 105 106동 사이 지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('라이프타운아파트(102 103동과 105 106동 사이 지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.122506,36.803311).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>상록수현대4차아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('상록수현대4차아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.121881,36.795797).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>우리은행 천안중앙금융센터(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('우리은행 천안중앙금융센터(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.135536,36.819825).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>월봉일성아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('월봉일성아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.116889,36.7958963).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>월봉벽산태영아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('월봉벽산태영아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.116353,36.798431).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>월봉대우아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('월봉대우아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.115517,36.795711).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>월봉현대아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('월봉현대아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.113956,36.795886).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>월봉청솔2차아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('월봉청솔2차아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.116247,36.793747).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>용암마을아파트(110동 앞 지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('용암마을아파트(110동 앞 지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.1177065,36.802492).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>직산코아루아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('직산코아루아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.153011,36.877958).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>직산세광엔리치빌1차2단지아파트(전동 지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('직산세광엔리치빌1차2단지아파트(전동 지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.150714,36.880231).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>직산세광엔리치빌1차1단지아파트(전동 지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('직산세광엔리치빌1차1단지아파트(전동 지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.152581,36.879311).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>직산부영아파트(전 지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('직산부영아파트(전 지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.137981,36.8939117).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>신동아파밀리에아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('신동아파밀리에아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.144439,36.807542).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>천안축구센터(본관동 지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('천안축구센터(본관동 지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.145911,36.821442).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>현대6차1단지아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('현대6차1단지아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.121942,36.791344).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>현대6차2단지아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('현대6차2단지아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.124028,36.791794).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>계룡푸른마을아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('계룡푸른마을아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.123719,36.793908).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>선경해누리아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('선경해누리아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.1246443,36.792414).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>쌍용현대3차아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('쌍용현대3차아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.1303965,36.795964).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>쌍용동일하이빌아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('쌍용동일하이빌아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.114369,36.786133).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>쌍용역푸르지오아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('쌍용역푸르지오아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.118725,36.790908).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>백석계룡리슈빌아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('백석계룡리슈빌아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.122353,36.832686).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>백석2차아이파크아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('백석2차아이파크아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.121447,36.825206).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>부경파크빌아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('부경파크빌아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.128207,36.827372).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>신세계아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('신세계아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.305456,36.767391).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>아우내아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('아우내아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.295245,36.760879).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>레이크팰리스 아파트(지하2층 주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('레이크팰리스 아파트(지하2층 주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.316409,36.764516).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>북면 중앙아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('북면 중앙아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.269026,36.770101).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>천안예술의전당(지하2층주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('천안예술의전당(지하2층주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.2258439,36.756358).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>용곡마을세광2차엔리치타워아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('용곡마을세광2차엔리치타워아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.138106,36.781124).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>고운여의주 아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('고운여의주 아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.177274,36.830204).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>불당리더힐스아파트(지하2층 주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('불당리더힐스아파트(지하2층 주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.103508,36.822498).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>불당 호반베르디움센트로포레(1-B 지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('불당 호반베르디움센트로포레(1-B 지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.100864,36.818558).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>불당 중흥S클래스 프라디움 레이크(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('불당 중흥S클래스 프라디움 레이크(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.158631,36.786889).transform("EPSG:4326", "EPSG:3857")
	       		},
			{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>불당 호반써밋플레이스(지하2층 주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('불당 호반써밋플레이스(지하2층 주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.104868,36.811573).transform("EPSG:4326", "EPSG:3857")
	       		},
			{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>한성아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('한성아파트')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.244887,36.915581).transform("EPSG:4326", "EPSG:3857")
	       		},
	       		{
	       			title:"<div style=' position: relative; border-bottom: 1px solid #dcdcdc; line-height: 18px; padding: 0 35px 2px 0;'>"+
				    "<div style='font-size: 12px; line-height: 15px;'>"+
			        "<span style='display: inline-block; width: 14px; height: 14px; background-image: url(/resources/images/common/icon_blet.png); vertical-align: middle; margin-right: 5px;'></span>연합아파트(지하주차장)"+
			    "</div>"+
			 "</div>"+
			 "<div style='position: relative; padding-top: 5px; display:inline-block'>"+
			 	
			    "<div style='display:inline-block; margin-left:5px; vertical-align: top;'>"+
			    	"<span style='font-size: 12px; margin-left:2px; margin-bottom:2px; display:block;'>------------------------------------------------"+
			    	"<span style='font-size: 12px; color:#888; margin-left:2px; margin-bottom:2px; display:block;'>-----------------------------------</span>"+
			    	"<span style='font-size: 12px; margin-left:2px;'><a href='http://localhost:9090/OSS/list.jsp?title="+encodeURI('연합아파트(지하주차장)')+"' target='blank'>커뮤니티 이동</a></span>"+
			    "</div>"+
			 "</div>",
	       	        lonlat: new Tmap.LonLat(127.2092506,36.912786).transform("EPSG:4326", "EPSG:3857")
	       		}
	       	];
	    		for (var i = 0; i < positions.length; i++){
	    			var icon = new Tmap.Icon('http://tmapapis.sktelecom.com/upload/tmap/marker/pin_b_m_a.png',size, offset); // 마커 아이콘
	    			var lonlat = positions[i].lonlat; // 마커 위치
	    			var title = positions[i].title; // 마커 타이틀
	    			marker = new Tmap.Marker(lonlat, icon); // 마커생성
	    			markerLayer.addMarker(marker);  // 마커 레이어에 마커 추가
	    			//팝업 생성
	    			popup = new Tmap.Popup("p1", positions[i].lonlat, new Tmap.Size(120, 30), positions[i].title);
	    			popup.setBorder("1px solid #8d8d8d");//popup border 조절
	    			popup.autoSize=true;//popup 사이즈 자동 조절	
	    			map.addPopup(popup); // 지도에 팝업 추가
	    			
	    			popup.hide(); // 팝업 숨기기
	    			                         

	    			//마커 이벤트등록
	    			marker.events.register("mouseover", new MarkerPopup(marker, popup), onOverMarker); // 마커위로 마우스 포인터가 들어왔을 때 이벤트 설정
	    			marker.events.register("mouseout", new MarkerPopup(marker, popup), onOutMarker); // 마커위에 있던 마우스 포인터가 밖으로 나갔을 때 이벤트 설정
	    			marker.events.register("click", new MarkerPopup(marker, popup), onClickMarker); // 마커를 클릭했을 때 이벤트 설정
	    		}

	       	
	}
	// 나의 위치정보를 나타낼 메서드
	function geoLocation(location) {
	    navigator.geolocation.getCurrentPosition(function(position){
	        // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
	        lat = position.coords.latitude; // 위도
	        lon = position.coords.longitude; // 경도

	        moveCoordinate(location, lon, lat);
	    });
	}

	function moveCoordinate (value, x, y) {
	    var PR_3857 = new Tmap.Projection("EPSG:3857");  // Google Mercator 좌표계인 EPSG:3857
	    var PR_4326 = new Tmap.Projection("EPSG:4326");  // WGS84 GEO 좌표계인 EPSG:4326

	    lonlat = new Tmap.LonLat(x, y).transform(PR_4326, PR_3857);

	    setXY(value, x, y);
	    
	    setMarker(value,lonlat);

	    map.setCenter(lonlat); // geolocation으로 얻어온 좌표로 지도의 중심을 설정합니다.
	}

	// 맵 클릭할 경우 마커 표시 메서드
	function onClick(e){
	    lonlat = map.getLonLatFromViewPortPx(e.xy).transform("EPSG:3857", "EPSG:4326");//클릭 부분의 ViewPortPx를 LonLat 좌표로 변환합니다.
	    x = lonlat.lon;
	    y = lonlat.lat;

	    if(input_s == 0) {
	        if(input_e == 0) {
	            removeMarker("e");
	            resetResult();
	        }
	        removeMarker("s");
	        setLocation("#start", x, y, lonlat);
	    } else if(input_e == 0) {
	        removeMarker("e");
	        setLocation("#end", x, y, lonlat);
	    } else {
	        removeMarker("s");
	        removeMarker("e");
	        reset();
	    }
	}
	// 마커에 마우스가 오버되었을 때 발생하는 이벤트 함수입니다.
	function onOverMarker(e) {
		this.popup.show(); // 마커에 마우스가 오버되었을 때 팝업이 보입니다. 
		
		markerLayer.removeMarker(this.marker); // 기존의 마커를 지웁니다.
		size = new Tmap.Size(48, 75); // 마커 사이즈 지정
		icon = new Tmap.Icon('http://tmapapis.sktelecom.com/upload/tmap/marker/pin_b_b_a.png',size, offset); // 마커 아이콘 지정
		marker = new Tmap.Marker(this.marker.lonlat, icon); // 마커 생성
		markerLayer.addMarker(marker); // 마커레이어에 마커 추가
		marker.events.register("mouseout", new MarkerPopup(marker, this.popup), onOutMarker); // 마커위에 있던 마우스 포인터가 밖으로 나갔을 때 이벤트 설정
		marker.events.register("click", new MarkerPopup(marker, this.popup), onClickMarker); // 마커를 클릭했을 때 이벤트 설정
	}
	// 마커에 마우스가 아웃되었을 때 발생하는 이벤트 함수입니다.
	function onOutMarker(e) {
		this.popup.hide(); // 마커에 마우스가 없을땐 팝업이 숨겨집니다.
		
		markerLayer.removeMarker(this.marker); // 기존의 마커를 지웁니다.
		size = new Tmap.Size(24, 38); // 마커 아이콘 사이즈 설정
		icon = new Tmap.Icon('http://tmapapis.sktelecom.com/upload/tmap/marker/pin_b_m_a.png',size, offset); // 마커 아이콘 지정
		marker = new Tmap.Marker(this.marker.lonlat, icon); // 마커 생성
		markerLayer.addMarker(marker); // 마커레이어에 마커 추가
		marker.events.register("mouseover", new MarkerPopup(marker, this.popup), onOverMarker); // 마커위로 마우스 포인터가 들어왔을 때 이벤트 설정
	}
	// 마커가 클릭되었을 때 발생하는 이벤트 함수입니다.
	function onClickMarker(e) {
		this.popup.hide(); // 클릭했을때 팝업이 숨겨집니다.
		
		if( selectMarker ) {
			
			// 기존 빨간 마커 지우기
			markerLayer.removeMarker(selectMarker);
			// 기존 빨간 마커 파란 마커로 다시 그리기
			size = new Tmap.Size(24, 38); // 마커 아이콘 사이즈 지정
			icon = new Tmap.Icon('http://tmapapis.sktelecom.com/upload/tmap/marker/pin_b_m_a.png',size, offset); // 마커 아이콘 생성
			marker = new Tmap.Marker(selectMarker.lonlat, icon); // 마커 생성
			markerLayer.addMarker(marker); // 마커레이어에 마커 추가
			if(input_s == 0) {
		        if(input_e == 0) {
		            removeMarker("e");
		            resetResult();
		        }
		        removeMarker("s");
		        setLocation("#start", x, y, lonlat);
		    } else if(input_e == 0) {
		        removeMarker("e");
		        setLocation("#end", x, y, lonlat);
		    } else {
		        removeMarker("s");
		        removeMarker("e");
		        reset();
		    }
			marker.events.register("mouseover", new MarkerPopup(marker, selectPopup), onOverMarker); // 마커위로 마우스 포인터가 들어왔을 때 이벤트 설정
		}
		
		// 빨간 마커 그리기
		markerLayer.removeMarker(this.marker); // 마커 삭제
		size = new Tmap.Size(24, 38); // 마커 아이콘 사이즈 지정
		icon = new Tmap.Icon('http://tmapapis.sktelecom.com/upload/tmap/marker/pin_r_m_a.png',size, offset); // 마커 아이콘 생성
		marker = new Tmap.Marker(this.marker.lonlat, icon); // 마커 생성
		selectMarker=marker; // 선택된 마커 저장
		selectPopup=this.popup; // 선택된 팝업 저장 
		markerLayer.addMarker(marker); // 마커레이어에 마커 추가
	}


	function resetResult() { // 출력 정보 리셋
	    $("#result").text("");
	    $("#result1").text("");
	    $("#result2").text("");
	    $("#result3").text("");
	}

	function setLocation(value, x, y, lonlat) {
	    if (value == "#start"){
	        setXY("s", x, y);
	        lonlat = lonlat.transform("EPSG:4326", "EPSG:3857"); //마커 정보 등록
	        setMarker("s");
	    } else if(value == "#end") {
	        setXY("e", x, y);
	        lonlat = lonlat.transform("EPSG:4326", "EPSG:3857"); //마커 정보 등록
	        setMarker("e");
	    }
	}

	function setMarker(value) {
	    if(value == "s") {
	        markerLayer_s.removeMarker(markerA);
	        markerA = new Tmap.Marker(lonlat, icon_s); //마커 정보 등록
	        markerLayer_s.addMarker(markerA);
	    } else if(value == "e") {
	        markerLayer_e.removeMarker(markerB);
	        markerB = new Tmap.Marker(lonlat, icon_e);
	        markerLayer_e.addMarker(markerB);
	    }
	}

	function icon(value) {
	    if(value != "s" && value != "e") {
	        value == "s";
	    }
	    var size = new Tmap.Size(24, 38);
	    var offset = new Tmap.Pixel(-(size.w / 2), -(size.h));
	    var icon = new Tmap.IconHtml('<img src=http://tmapapis.sktelecom.com/upload/tmap/marker/pin_r_m_'+value+'.png />',size, offset);
	    return icon;
	}

	function removeMarker(value) {
	    if(value == "s") {
	        markerLayer_s.removeMarker(markerA);
	        markerA = null;
	        start_x = null;
	        start_y = null;
	        $("#start").val("");
	    } else if(value == "e") {
	        markerLayer_e.removeMarker(markerB);
	        markerB = null;
	        end_x = null;
	        end_y = null;
	        $("#end").val("");
	    }
	}

	function setXY(value, x, y) {
	    if(value == "s") {
	        start_x = x;
	        start_y = y;
	        searchAdress("#start", y, x);
	    } else if(value == "e") {
	        end_x = x;
	        end_y = y;
	        searchAdress("#end", y, x);
	    } else {
	        console.log("value Error");
	    }
	}

	function reset () {
	    $("#start").val(null);
	    $("#end").val(null);
	    removeMarker("s");
	    removeMarker("e");
	    endInputS();
	    endInputE();
	    resetResult();
	    map.removeLayer(routeLayer);
	}

	function go() {
	    if (input_s == 1 && input_e == 1) {
	        distance();
	    } else if(input_s == 0){
	        alert("출발지를 등록하세요!");
	    } else {
	        alert("도착지를 등록하세요!");
	    }
	}

	var headers = {}; 
	headers["appKey"]="d9c9c610-76ec-4a74-b6b5-ef90cb8c2985";//실행을 위한 키 입니다. 발급받으신 AppKey를 입력하세요.

	function distance() {
	    if (start_x != null && end_x != null) {
	        $.ajax({
	            method:"POST",
	            headers:headers,
	            url:"https://api2.sktelecom.com/tmap/routes?version=1",
	            data:{
	                startX:start_x,
	                startY:start_y,
	                endX:end_x,
	                endY:end_y,
	                reqCoordType : "WGS84GEO",
	                resCoordType : "EPSG3857",
	                angle:"172",
	                searchOption:0
	            },
	            success:function(data) {
	                var obj = JSON.stringify(data);
	                obj = JSON.parse(obj);
	                var total = obj.features[0].properties;
	                var start = 0;
	                var end;

	                var time = "";
	                if(total.totalTime > 3600) {
	                    time = Math.floor(total.totalTime/3600) + "시간 " + Math.floor(total.totalTime%3600/60) + "분";
	                } else {
	                    time = Math.floor(total.totalTime%3600/60) + "분 ";
	                }

	                map.addLayer(routeLayer);
	                routeLayer.removeAllFeatures();
	                

	                var vector_format = new Tmap.Format.GeoJSON().read(data); 
	                
	                routeLayer.addFeatures(vector_format);

	                $("#result").text("소요 시간: " + time);
	                $("#result1").text("거리: " + total.totalDistance/1000+ "km ");
	                $("#result2").text("통행료: " + total.totalFare);
	                $("#result3").text("택시비: " + total.taxiFare);
	            },
	            error:function(request,status,error){
	                alert("출발지 혹은 도착지를 잘못 지정하였습니다.");
	                reset();
	                console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	            }
	        });
	    }
	}

	function searchAdress(input, lat, lon) {
	    $.ajax({
	        method: "GET",
	        url: "https://api2.sktelecom.com/tmap/geo/reversegeocoding?version=1",
	        data: {
	          lat: lat,
	          lon: lon,
	          appKey: headers["appKey"]
	        },
	        success: function(data) {
	            if(data != undefined) {
	            var obj = JSON.stringify(data);
	            obj = JSON.parse(obj);
	            } else {
	                alertAdress(input);
	            }
	            $(input).val(obj.addressInfo.fullAddress);
	        },
	        error:function(request,status,error){
	            alertAdress(input);
	            console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	        }
	    });
	}

	function alertAdress(input) {
	    alert("제공되지 않는 주소 범위입니다.");
	        if(input == "#start") {
	            removeMarker("s");
	        } else {
	            removeMarker("e");
	        }
	}

	function search(input) {
	    if($(input).val()=="") {
	        alert("입력값이 없습니다.");
	    } else {
	        textSearch(input, $(input).val());
	    }
	}

	function textSearch(input, add) {
	    if($(input).val() != null) {
	        $.ajax({
	            method: "GET",
	            url: "https://api2.sktelecom.com/tmap/geo/fullAddrGeo?version=1",
	            data: {
	               fullAddr: add,
	               appKey: headers["appKey"]
	            },
	            success: function(data) {
	                var obj = JSON.stringify(data);
	                obj = JSON.parse(obj);

	                if(obj.coordinateInfo != undefined) {
	                   var coordinate = obj.coordinateInfo.coordinate[0];
	                   if(coordinate.lon != "") {
	                       console.log(coordinate.lon);
	                        sOrE(input, coordinate.lon, coordinate.lat);
	                   } else if(coordinate.newLon != "") {
	                       console.log(coordinate.newLon);
	                        sOrE(input, coordinate.newLon, coordinate.newLat);
	                   }
	                } else {
	                    if (input == "#start") {
	                        alert("출발지 주소가 잘못되었습니다.");
	                    } else {
	                        alert("도착지 주소가 잘못되었습니다.");
	                    }
	                }
	            },
	            error:function(request,status,error){
	                console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	                
	            }
	        });
	    }
	}

	function sOrE (input, x, y) {
	    if(input == "#start") {
	        start_x = x;
	        start_y = y;
	        startInputS();
	        moveCoordinate("s", x,y);
	    } else if(input == "#end") {
	        end_x = x;
	        end_y = y;
	        startInputE();
	        moveCoordinate("e", x,y);
	    } else {
	        alert("잘못된 값을 입력하셨습니다.");
	    }
	}

	function startInputS() {
	    input_s = 1;
	}

	function endInputS() {
	    input_s = 0;
	}

	function startInputE() {
	    input_e = 1;
	}

	function endInputE() {
	    input_e = 0;
	}

	
   	
	</script>
	</div>
	
   
 </div>
 <div class = "col-lg-2">
			<table class="table table-striped" style="text-align:center; border:1px solid #dddddd"> 
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">대피소</th>
						<th style="background-color: #eeeeee; text-align: center;">사용금지</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>1</td>
						<td>이한별아파트</td>
						<td>X</td>
					</tr>
					<tr>
						<td>2</td>
						<td>주호승아파트</td>
						<td>X</td>
					</tr>
					<tr>
						<td>3</td>
						<td>김성민아파트</td>
						<td>X</td>
					</tr>
				</tbody>
			</table>	
		</div>
 <div class="col-lg-5">
<form class="offset-s6 col s3">
                <div class="row">
                    <div class="input-field col s12">
                        <input type="text" id="start" />
                        <div class="row">
                            <input class="waves-effect waves-light btn col s5" type="button" style="background-color: rgba(250, 170, 50, 0.5);"
                            value="출발지 등록" onclick="search('#start')">
                            <button class="waves-effect waves-light btn col s5" type="button" style="background-color: rgba(50, 170, 50, 0.5);" onclick="geoLocation('s')">
                                <i class="material-icons left">내 위치</i>
                            </button>
                        </div>
                    </div>
                </div>
                <br>
                <div class="row">
                    <div class="input-field col s12">
                        <input type="text" id="end" />
                        <div class="row">
                            <input class="waves-effect waves-light btn col s5" type="button" style="background-color: rgba(250, 170, 50, 0.5);"
                            type="button" value="도착지 등록" onclick="search('#end')">
                            <button class="waves-effect waves-light btn col s5" type="button" style="background-color: rgba(50, 170, 50, 0.5);" onclick="geoLocation('e')">
                                <i class="material-icons left">내 위치</i>
                            </button>
                        </div>
                    </div>
                	</div>
                	<br>
                	<div class="row">
        	       			<div class="submit col s12">
            	 	 			  <button class="col-lg-2" type="button" onclick="go()">
              			  		<i class="material-icons right">경로탐색</i>
              		 	 		</button>
              		  		</div>
               		 </div>            
            </form>
 				<div class="result col s3">
                	<p id="result" class="center-align"></p>
                	<p id="result1" class="center-align"></p>
                	<p id="result2" class="center-align"></p>
                	<p id="result3" class="center-align"></p>
            	</div>
</div>
</div>

 

 <!-- 애니매이션 담당 JQUERY -->

 <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script> 

 <!-- 부트스트랩 JS  -->

 <script src="js/bootstrap.js"></script>

 

</body>

</html>