<%@ page contentType="text/html; charset=UTF-8" %>
<%
  String filename = request.getParameter("filename");

  if(filename.indexOf("..") != -1 || filename.indexOf("/") != -1) {
    out.println("check~!");
  } else {
    out.println("bypass");
  }
%>