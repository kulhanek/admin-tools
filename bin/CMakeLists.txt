# ==============================================================================
# AdminTools CMake File
# ==============================================================================

INSTALL(FILES
            nodes-apt-diff
            nodes-apt-get
            nodes-apt-install-common
            nodes-run-cmd
            nodes-sync-pkgs             
        DESTINATION
            bin
        PERMISSIONS
            OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE OWNER_READ GROUP_READ WORLD_READ
        )

