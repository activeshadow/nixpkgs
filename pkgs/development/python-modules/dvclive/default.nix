{ lib
, buildPythonPackage
, dvc
, dvc-studio-client
, fetchFromGitHub
, funcy
, pytestCheckHook
, pythonOlder
, ruamel-yaml
, scmrepo
, setuptools-scm
, tabulate
}:

buildPythonPackage rec {
  pname = "dvclive";
  version = "2.11.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-zr8fLRwan1/G8RMHa6lf4Qa5fTh5DzVLO53PMW0fm4c=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dvc
    dvc-studio-client
    funcy
    ruamel-yaml
    scmrepo
  ];

  # Circular dependency with dvc
  doCheck = false;

  pythonImportsCheck = [
    "dvclive"
  ];

  meta = with lib; {
    description = "Library for logging machine learning metrics and other metadata in simple file formats";
    homepage = "https://github.com/iterative/dvclive";
    changelog = "https://github.com/iterative/dvclive/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
