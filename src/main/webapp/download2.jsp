<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*,java.io.*"%>
<%
  // 파일 입출력을 위한 스트림 객체 선언
  // FileInputStream은 파일에서 데이터를 바이트 단위로 읽어오는 클래스, 사용자가 다운로드 원하는 파일을 바이트 단위로 읽어온다.
  FileInputStream fis = null;
  // FileInputStream을 직접 사용하면 파일에서 데이터를 1바이트씩 읽어오게 됩니다. 이는 매우 비효율적인 방식입니다. 왜냐하면:
  // 매번 1바이트를 읽기 위해 시스템, 호출 => 버퍼 입출력을 사용하여 데이터를 일정량씩 모아서 한 번에 처리하게 효율적인 동작 가능
  BufferedInputStream bis = null;
  BufferedOutputStream bos = null;

  // 파일 경로의 일부를 파라미터로 받아옴
  String path_temp = request.getParameter("path");
  // 전체 파일 경로 구성 (기본 경로 + 파라미터로 받은 경로)
  String path = "C:\\Users\\yeong\\IdeaProjects\\FileDownloadJSP\\src\\main\\webapp\\upload\\" + path_temp + "\\";
  // 사용자가 다운로드할 때 보여질 파일명
  String org_filename = request.getParameter("org_filename");
  // 서버에 실제로 저장된 파일명
  String real_filename = request.getParameter("real_filename");

  // 파일명 파라미터 유효성 검사
  if(org_filename == null || real_filename == null) {
    out.println("<script>alert('파일명이 입력되지 않았습니다.');history.back(-1);</script>");
    return;
  }

  try {
    // 실제 파일 객체 생성
    File fd = new File(path + real_filename);

    // 파일 존재 여부 확인
    if(!fd.exists()) {
      out.println("<script>alert('파일이 존재하지 않습니다.');history.back(-1);</script>");
      return;
    }

    // 응답 헤더 설정
    // Content-Type을 application/octet-stream으로 설정하여 모든 종류(파일 타입)의 이진 데이터를 처리할 수 있게 함
    response.setHeader("Content-Type", "application/octet-stream");
    // Content-Disposition을 attachment로 설정하여 브라우저가 파일을 다운로드하도록 지시
    response.setHeader("Content-Disposition", "attachment; filename=" + org_filename);

    // 파일 입출력을 위한 스트림 객체 생성
    fis = new FileInputStream(fd);
    bis = new BufferedInputStream(fis);
    bos = new BufferedOutputStream(response.getOutputStream());

    // 파일을 읽고 쓰기 위한 버퍼와 카운터 변수
    byte[] buffer = new byte[1024];
    int i = 0;

    // 파일의 내용을 버퍼 단위로 읽어 응답 출력 스트림에 쓰기
    while((i=(bis.read(buffer))) != -1) {
      bos.write(buffer, 0, i);
    }
    // 버퍼에 남아있는 내용을 모두 출력
    bos.flush();
  } finally {
    // 사용한 모든 스트림 객체를 닫아 리소스 해제
    if(fis != null) fis.close();
    if(bis != null) bis.close();
    if(bos != null) bos.close();
  }
%>
