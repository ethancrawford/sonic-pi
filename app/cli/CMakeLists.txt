project(sonic-pi-cli VERSION 0.1.0.0)

set(APP_NAME ${PROJECT_NAME})

# Set additional project information
set(COMPANY "Sonic Pi")
set(COPYRIGHT "Copyright (c) 2021 Sonic Pi")
set(IDENTIFIER "com.sonic-pi-cli")

set(APP_ROOT ${CMAKE_CURRENT_LIST_DIR})

set(SPICLI_APP_SOURCE
    ${APP_ROOT}/main.cpp
    ${APP_ROOT}/CMakeLists.txt
    )

set(SPICLI_CORE_SOURCE
    ${APP_ROOT}/../core/core.h
    ${APP_ROOT}/../core/core.cpp
)

add_executable (${APP_NAME}
    ${SPICLI_APP_SOURCE}
    ${SPICLI_CORE_SOURCE}
    )

FILE(COPY ../core/res/logo.txt DESTINATION .)
source_group ("Cli" FILES ${SPICLI_APP_SOURCE})
source_group ("Core" FILES ${SPICLI_CORE_SOURCE})

