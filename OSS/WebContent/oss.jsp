<%@ page language="java" contentType="text/html; charset=UTF-8"

	pageEncoding="UTF-8"%>

<%@ page import="java.io.PrintWriter"%>

<!DOCTYPE html>

<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<!-- 뷰포트 -->

<meta name="viewport" content="width=device-width" initial-scale="1">

<!-- 스타일시트 참조  -->

<link rel="stylesheet" href="css/bootstrap.css">

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

			<a class="navbar-brand" href="NewFile1.jsp">내 주변 대피소 찾기</a>

		</div>

		<div class="collapse navbar-collapse"

			id="#bs-example-navbar-collapse-1">

			<ul class="nav navbar-nav">

				<li><a href="NewFile1.jsp">메인</a></li>

				<li class="active"><a href="oss.jsp">게시판</a></li>

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

	<!-- 게시판 -->

	<div class="container">

		<div class = "row">

			<table class="table table-striped" style="text-align:center; border:1px solid #dddddd"> 

				<thead>

					<tr>

						<th style="background-color: #eeeeee; text-align: center;">번호</th>

						<th style="background-color: #eeeeee; text-align: center;">제목</th>

						<th style="background-color: #eeeeee; text-align: center;">작성자</th>

						<th style="background-color: #eeeeee; text-align: center;">작성일</th>

					</tr>

				</thead>

				<tbody>

					<tr>

						<td>1</td>

						<td>안녕하세요</td>

						<td>김성민</td>

						<td>2019-05-21</td>

					</tr>

				</tbody>

			</table>	

			<a href = "write.jsp" class="btn btn-primary pull-right">글쓰기</a>

		</div>

	</div>

	
	<!-- 애니매이션 담당 JQUERY -->

	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

	<!-- 부트스트랩 JS  -->

	<script src="js/bootstrap.js"></script>
	</body>
</html>
