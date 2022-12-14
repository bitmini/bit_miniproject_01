<%@page import="java.util.concurrent.ExecutionException"%>
<%@page import="javax.naming.Context"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@page import="java.util.*, java.sql.*, org.ai.beans.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
#freeBoardView {
	display: inline-block;
	float: right;
	width: 1400px;
	height: 1800px;
	margin-top: 200px;
	text-align: center;
}
</style>
</head>
<body>
<%
request.setCharacterEncoding("utf-8");  
int number = 0; 
String writer = null;
String title = null;
String regDate = null;
String content = null;
String imageFileName = null;
String fileName = null;
String path = request.getServletContext().getContextPath()+"/upload/";
String boardTitle = request.getParameter("boardTitle");
/* 상대경로 지정 */
int views = 0;
int recommends = 0;

try {
	number= Integer.parseInt(request.getParameter("number"));
} catch (Exception e){
	response.sendRedirect("./freeBoardForm.jsp");
}
%>
<%	
/* db내에서 글번호 조회 */
	String url = "jdbc:mysql://localhost:3306/miniProject1?useSSL=false&allowPublicKeyRetrieval=true";
	String sql = null;
	String user = "root";
	String password = "1234";
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	ArrayList<Board> bList = new ArrayList<Board>();
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url, user, password);
		sql = "select * from board";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		while(rs.next()){
			bList.add(new Board(rs.getInt(1), rs.getInt(2), rs.getInt(3), rs.getString(4), rs.getString(5), rs.getString(6),
					rs.getString(7), rs.getString(8), rs.getString(9), rs.getString(10)));
		}
		for(int i = 0; i < bList.size(); i++){
			if(number == bList.get(i).getNumber()){
				writer = bList.get(i).getWriter();
				title = bList.get(i).getTitle();
				regDate = bList.get(i).getRegDate();
				content = bList.get(i).getContent();
				views = bList.get(i).getViews();
				recommends = bList.get(i).getRecommends();
				if(bList.get(i).getImageFileName() != null){
					request.setAttribute("imageFileName", bList.get(i).getImageFileName());
				}
				if(bList.get(i).getFileName() != null){
					request.setAttribute("fileName", bList.get(i).getFileName());
				}
			}
		}
		views += 1;
		sql = "update board set views = ? where number = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, views);
		pstmt.setInt(2, number);
		pstmt.executeUpdate();
	} catch (Exception e){
		e.printStackTrace();
	}
%>
<%
String nickName = (String)session.getAttribute("nickName");
ArrayList<Comment> cList = new ArrayList<Comment>();
ArrayList<Comment> cList2 = new ArrayList<Comment>();
request.setAttribute("nickName", nickName);  
// 댓글이 있는지 찾기 위해서 댓글 db에서 서치
sql = "select * from Comment";
pstmt = conn.prepareStatement(sql);
rs = pstmt.executeQuery();
while(rs.next()){
	cList.add(new Comment(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4)));
}
for(int i = 0; i < cList.size(); i++){
	if(cList.get(i).getNumber() == number){
		cList2.add(cList.get(i));
	}
}
if(cList2 != null){
	request.setAttribute("cList", cList2);
}
request.setAttribute("writer", writer);
%>

<%if(session.getAttribute("userId") != null){ %>
<jsp:include page="./header2.jsp"></jsp:include>
<%} 
else {%>
<jsp:include page="./header.jsp"></jsp:include>
<%}%>
<div id="content">
<div id="freeBoardView">
<<<<<<< HEAD
    <div class="container">
        <div class="row">
            <table class="table table-striped" style="text-align:center; border:1px solid #dddddd">
                <thead>
                    <tr>
                        <th colspan="3" style="background-color: #eeeeee; text-align:center;">게시판 글보기</th>
                    </tr>
                </thead>
                <tbody>
                <!--    </p> -->
                    <tr>
                        <td style="width:20%;">글제목</td>
                        <td colspan="2"><%=title %></td>조회 :<%=views %>&nbsp;&nbsp; 추천 :<%=recommends %>
                    </tr>
                    <tr>
                        <td>작성자</td>
                        <td colspan="2"><%=writer %></td>
                    </tr>
                    <tr>
                        <td>작성일자</td>
                        <td colspan="2"><%=regDate %></td>
                    </tr>
                    <tr>
                        <td>내용</td>
                        <td colspan="2" style="min-height:200px; text-align:left;"><img alt="" src="<%=path%>${imageFileName}" onerror="this.style.display='none'"> <br><%=content%></td>
                    </tr>
                </tbody>
            </table>
    </div>
</div>

<br>
=======
		<p style="float: left;">닉네임 : <%=writer %></p> <p style="text-align: center;">작성일 : <%=regDate %></p>  <p style="float: right; margin-top:-40px"> 조회 : <%=views %> &nbsp; 추천 : <%=recommends %></p>
	<hr>
	<div>
	<h1><%=title %></h1>
	</div>
	<hr>
<div>
	<!-- 파일 다운로드 servlet 만들어서 다운로드 받게 해야함 -->
	<!-- 파일 명을 넘겨주고.. realpath처리.. -->
		<img alt="" src="<%=path%>${imageFileName}" onerror="this.style.display='none'"> <br>
		<p><%=content%></p>
</div> <br>
>>>>>>> branch 'master' of https://github.com/bitmini/bit_miniproject_01.git
<c:set var ="number" value="<%=number %>"></c:set>
<form action="./recommendsProcess.do?number=${number}" method="post">
	<!-- 추천을 누르면 현재 게시글 정보의 추천이 process로 가서 1 올라서 다시 일로와야해 -->
	<input style="text-align: center; width: 100px; height: 50px; border-radius: 20px; color : white; background-color: #343a40;" type="submit" value="추천">
</form> <br>
<a href="./freeBoardForm.jsp" id="freeBoardForm" style="display: none;"></a>
<input type="button" value="목록으로" style="
	border: 1px solid black;
	" onclick="document.getElementById('freeBoardForm').click();"
	/>
<%if(writer.equals((String)session.getAttribute("nickName"))){
session.setAttribute("title", title);
session.setAttribute("content", content);
session.setAttribute("imageFileName", imageFileName);
session.setAttribute("number", number);
%>
<a href="./boardUpdate.jsp?boardTitle=<%=boardTitle%>"id="boardUpdate" style="display: none;"></a>
<input type="button" value="수정하기" style="
	border: 1px solid black;
	" onclick="document.getElementById('boardUpdate').click();"
	/>
<%} %>
<hr>

<div>
<jsp:include page="./searchCommentProcess.jsp">
	<jsp:param value="${number}" name="number"/>
	<jsp:param value="${writer}" name="writer"/>
</jsp:include>
</div>
	<!-- 댓글을 달면, 글번호(number), 글작성자(nickname), 댓글내용은 새로받은 내용(comment), 댓글 단 시간이 regDate -->
<%if(session.getAttribute("userId") != null){%>
<div>
	<div>
	<strong style="margin-top: 20px; display: inline-block; float: left;">${nickName}</strong>
	</div>
	<div>
	<form action="./saveComment.do?number=${number}&writer=${nickName}" method = "post"> 
		<textarea style="border: 1px solid #abadb3; height: 80px" rows="" cols="100" name="comment"></textarea>
		<input type="submit" style="padding-bottom: -5px;" value="등록">
	</form>
	</div>
</div>
<%}%>
</div>
</div>
<%conn.close(); %>
<jsp:include page="./footer.jsp"></jsp:include>
</body>
</html>