#!/bin/bash


# chmod +x wmctrl_retry.sh
############################################
# 환경 변수 설정
############################################
XVFB_DISPLAY=":99"
XAUTH_FILE="/tmp/.Xauthority_${XVFB_DISPLAY}"

export DISPLAY="${XVFB_DISPLAY}"
export XAUTHORITY="${XAUTH_FILE}"

############################################
# 설정값
############################################
MAX_RETRIES=5
DELAY_SECONDS=10
SEARCH_STRING="grass"

echo
echo "[ wmctrl -l ] = 실행"
echo "============================"
echo

############################################
# 재시도 루프
############################################
for ((attempt=1; attempt<=MAX_RETRIES; attempt++)); do
    echo "### 시도 ${attempt}/${MAX_RETRIES} 시작 ###"

    echo "✅ 환경 변수 설정 완료: DISPLAY=${DISPLAY}, XAUTHORITY=${XAUTHORITY}"
    echo "------------------------------"

    ############################################
    # wmctrl -l 실행
    ############################################
    echo "창 목록 확인..."
    WMCTRL_LIST=$(wmctrl -l 2>&1)
    RET=$?

    if [ $RET -ne 0 ]; then
        echo "❌ 'wmctrl -l' 실행 중 오류 발생:"
        echo "${WMCTRL_LIST}"
    else
        echo "${WMCTRL_LIST}"
    fi

    ############################################
    # 문자열 포함 여부 확인
    ############################################
    if echo "${WMCTRL_LIST}" | grep -q "${SEARCH_STRING}"; then
        echo "✅ 실행 성공: '${SEARCH_STRING}' // 포함 -- O"
        echo "------------------------------"
        echo "창 숨기기"

        COMMAND_HIDE="wmctrl -r 'grass' -b add,hidden"
        HIDE_OUTPUT=$(eval ${COMMAND_HIDE} 2>&1)
        RET=$?

        if [ $RET -ne 0 ]; then
            echo "❌ '${COMMAND_HIDE}' 실행 중 오류 발생:"
            echo "${HIDE_OUTPUT}"
        else
            if [ -n "${HIDE_OUTPUT}" ]; then
                echo "${HIDE_OUTPUT}"
            else
                echo "✅ 명령어 실행 완료: ${COMMAND_HIDE}"
            fi
            break  # 성공 → 루프 종료
        fi
    else
        echo "❌ 실행 실패: '${SEARCH_STRING}' // 미포함 -- X"
    fi

    ############################################
    # 딜레이 처리
    ############################################
    if [ $attempt -lt $MAX_RETRIES ]; then
        echo "${DELAY_SECONDS}초 대기 후 재실행합니다..."
        sleep ${DELAY_SECONDS}
    else
        echo "⚠️ 최대 재시도 횟수(${MAX_RETRIES}회)에 도달했습니다. 최종적으로 실행에 실패했습니다."
    fi
done
