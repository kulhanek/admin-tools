# ==============================================================================
# AdminTools CMake File
# ==============================================================================

INSTALL(FILES
            nodes-apt-diff
            nodes-apt-get
            nodes-run-cmd
            nodes-offline
        DESTINATION
            bin
        PERMISSIONS
            OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE OWNER_READ GROUP_READ WORLD_READ
        )

