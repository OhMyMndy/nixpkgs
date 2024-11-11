{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec
{
  pname = "zeal-cli";
  version = "2.0.0-dev3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Morpheus636";
    repo = "zeal-cli";
    rev = "v${version}";
    sha256 = "sha256-z8127O6dZZmHQntf8+S8AQadn9QcskUFkrt8f2VylzA=";
  };

  dependencies = with python3Packages; [
    requests
    beautifulsoup4
    lxml
    pyyaml
  ];

  build-system = [ python3Packages.poetry-core ];

  patchPhase = ''
    sed -iE 's/lxml = .*/lxml = "^5.1.0"/' pyproject.toml >/dev/null
  '';

  meta = with lib; {
    homepage = "https://github.com/Morpheus636/zeal-cli/";
    description = "Asciidoc-based literate programming tool, written in Python.";
    mainProgram = "zeal-cli";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = [ maintainers.OhMyMndy ];
  };
}
