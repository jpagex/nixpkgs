{ lib, fetchFromGitHub, python3Packages, sqlite, which }:

python3Packages.buildPythonApplication rec {
  pname = "s3ql";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "release-${version}";
    sha256 = "0a6ll5vs7faj1klfz3j674399qfbhy3blp3c5wwsqvcdkpcjcx11";
  };

  checkInputs = [ which ] ++ (with python3Packages; [ cython pytest pytest-trio ]);
  propagatedBuildInputs = with python3Packages; [
    sqlite apsw pycrypto requests defusedxml dugong
    google-auth google-auth-oauthlib trio pyfuse3
  ];

  preBuild = ''
    ${python3Packages.python.interpreter} ./setup.py build_cython build_ext --inplace
  '';

  checkPhase = ''
    # Removing integration tests
    rm tests/t{4,5,6}_*
    pytest tests
  '';

  meta = with lib; {
    description = "A full-featured file system for online data storage";
    homepage = "https://github.com/s3ql/s3ql/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rushmorem ];
    platforms = platforms.linux;
  };
}
