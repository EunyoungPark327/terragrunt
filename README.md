# Terragrunt Infrastructure

## Summary

이 레포는 AWS 인프라를 **Terraform + Terragrunt** 로 관리하면서

- 환경별(`dev`, `prd`)로 **EC2 인스턴스 3종(C, M, T 타입)** 을 프로비저닝하고
- 각 인스턴스마다 팀별 태그를 부여,
- 공통 정책(EBS 암호화, gp3 기본 볼륨, T 시리즈 Credit 제한)을 기본값으로 적용
- SG 및 IAM Role 은 공용 값(하드코딩)으로 지정
- GitHub Actions 를 이용해 **자동 Plan 코멘트**와 **승인 기반 Apply 배포**를 수행합니다.

구체적으로:

- PR 에서 변경된 `live/**` 디렉터리만 대상으로 `terragrunt run-all plan` 실행
- `tfcmt` 를 이용해 GitHub PR 에 **Plan 결과를 코멘트**로 남김
- main 브랜치에 머지되면, **환경 승인(approver)** 후 `terragrunt run-all apply` 자동 실행
- `.terragrunt-cache` 경로는 PR 코멘트 제목에서 숨기고, 라벨은 생성하지 않음

---

## Requirements

### Tools & Versions

| Name       | Version   |
| ---------- | --------- |
| terraform  | >= 1.13.0 |
| terragrunt | 0.55.2    |
| tfcmt      | 4.11.0    |
| aws        | ~> 6.0    |

## Directory Structure

```bash
.
├── gha-tfwrapper.sh          # tfcmt + terraform wrapper
├── .tfcmt.yml                # tfcmt config (PR 코멘트 설정)
├── live                      # Terragrunt live configuration
│   ├── dev
│   │   ├── common.hcl
│   │   └── ec2
│   │       └── terragrunt.hcl
│   ├── prd
│   │   ├── common.hcl
│   │   └── ec2
│   │       ├── c-type
│   │       │   └── terragrunt.hcl
│   │       ├── m-type
│   │       │   └── terragrunt.hcl
│   │       └── t-type
│   │           └── terragrunt.hcl
│   └── root.hcl
└── modules                   # Terraform modules
    └── ec2
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

- ```live/**/terragrunt.hcl``` : 각 환경/서비스별 Terragrunt 엔트리 포인트
- ```modules/ec2``` : 재사용 가능한 EC2 Terraform 모듈
- ```gha-tfwrapper.sh``` : ```terraform plan/apply``` 를 ```tfcmt``` 로 감싸서 PR 코멘트 생성
- ```.tfcmt.yml``` : tfcmt 템플릿 / 라벨 설정

---

## Usage

### 1. Local(optional)

```bash
cd live/dev/ec2
terragrunt plan
terragrunt apply
```

### 2. PR Workflow(Plan)

1. ```live/**``` 또는 ```modules/**``` 아래 코드를 수정하고 PR 생성
2. ```Terragrunt Plan``` 워크플로우가 자동 실행
3. 각 변경된 Terragrunt 디렉터리에 대해 PR 에 Plan 코멘트가 추가됨
4. ```Plan: add/change/destroy``` 수와 리소스 변경 내용을 코멘트에서 확인

### 3. Merge -> Apply Workflow

1. PR 리뷰 및 승인
2. main 브랜치로 머지
3. ```Terragrunt Apply``` 워크플로우가 트리거 됨
4. ```terragrunt-apply``` 환경에서 승인자가 Approve 하면 ```terragrunt run-all apply``` 가 실행되고, ```tfcmt``` 가 Apply 결과를 PR / 커밋에 코멘트로 남김