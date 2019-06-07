 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<!-- 뷰포트 -->
<meta name="viewport" content="width=device-width" initial-scale="1">

<!-- 스타일시트 참조  -->
<link rel="stylesheet" href="css/bootstrap.min.css">

<title>내 주변 대피소 찾기</title>

</head>
<body>
 <!-- 네비게이션  -->
 <nav class="navbar navbar-default">
  <div class="navbar-header">
   <button type="button" class="navbar-toggle collapsed" 
    data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
    aria-expaned="false">
     <span class="icon-bar"></span>
     <span class="icon-bar"></span>
     <span class="icon-bar"></span>
    </button>

    <a class="navbar-brand" href="NewFile1.jsp">내 주변 대피소 찾기</a>
  </div>
  <div class="collapse navbar-collapse" id="#bs-example-navbar-collapse-1">
   <ul class="nav navbar-nav">
    <li><a href="NewFile1.jsp">메인</a></li>
    <li><a href="oss.jsp">게시판</a></li>
   </ul>

   <ul class="nav navbar-nav navbar-right">
    <li class="dropdown">
     <a href="#" class="dropdown-toggle"
      data-toggle="dropdown" role="button" aria-haspopup="true"
      aria-expanded="false">접속하기<span class="caret"></span></a>
     <ul class="dropdown-menu">
      <li class="active"><a href="login.jsp">로그인</a></li>
      <li><a href="join.jsp">회원가입</a></li>    

     </ul>
    </li>
   </ul>
  </div> 
 </nav>

 <!-- 로긴폼 -->

 <div class="container">
  <div class="col-lg-4"></div>
  <div class="col-lg-4">
  
  <!-- 점보트론 -->
   <div class="jumbotron" style="padding-top: 20px;">

   <!-- 로그인 정보를 숨기면서 전송post -->
   <form method="post" action="loginAction.jsp">
    <h3 style="text-align: center;"> 로그인화면 </h3>
    <div class="form-group">
     <input type="text" class="form-control" placeholder="아이디" name="userID" maxlength="20">
    </div>

    <div class="form-group">
     <input type="password" class="form-control" placeholder="비밀번호" name="userPassword" maxlength="20">
    </div>

    <input type="submit" class="btn btn-primary form-control" value="로그인">
   </form>
  </div>
 </div>
</div>

<!-- 애니매이션 담당 JQUERY -->
 <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script> 

 <!-- 부트스트랩 JS  -->
 <script src="js/bootstrap.js"></script>

 </body>
</html>