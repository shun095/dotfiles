local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {
        vim.env.JAVA_HOME .. '/bin/java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-javaagent:' .. vim.env.HOME .. '/eclipse/jee-2024-09/Eclipse.app/Contents/Eclipse/lombok.jar',
        '-XX:+UseG1GC',
        '-XX:+UseStringDeduplication',
        '-Xms256m',
        '-Xmx2048m',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar',
        vim.env.HOME ..
        '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
        '-configuration', vim.env.HOME .. '/.local/share/nvim/mason/packages/jdtls/config_mac',
        '-data', vim.env.HOME .. '/.cache/jdtls/workspace'
    },
    root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),

    settings = {
        redhat = {
            telemetry = {
                enabled = false
            }
        },
        java = {
            inlayHints = {
                parameterNames = {
                    enabled = "all"
                }
            },
            implementationCodeLens = "all",
            referencesCodeLens = {
                enabled = true
            }
        }
    },
    capabilities = require('cmp_nvim_lsp').default_capabilities(),

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
        bundles = {
            vim.fn.glob(
                vim.env.HOME ..
                "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-0.53.1.jar",
                true)
        },
    },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require("inlay-hints").setup()
require('jdtls').start_or_attach(config)
