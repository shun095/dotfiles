local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fs.root(0, { ".git", ".zshrc" }), ':p:h:t')

local jdtls_path = require('mason-registry').get_package('jdtls'):get_install_path()
local java_debug_adapter_path = require('mason-registry').get_package('java-debug-adapter'):get_install_path()
local java_test_path = require('mason-registry').get_package('java-test'):get_install_path()

local bundles = {
    vim.fn.glob(java_debug_adapter_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
        true)
}

vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", true), "\n"))

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
        '-javaagent:' .. jdtls_path .. '/lombok.jar',
        '-XX:+UseParallelGC',
        '-XX:GCTimeRatio=4',
        '-XX:AdaptiveSizePolicyWeight=90',
        '-Dsun.zip.disableMemoryMapping=true',
        '-Xms128m',
        '-Xmx4096m',
        '--add-modules=javafx.media,javafx.web,javafx.swing,javafx.graphics,javafx.base,javafx.controls,javafx.fxml',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar', true),
        '-configuration', jdtls_path .. '/config_mac_arm',
        '-data', vim.env.HOME .. '/.cache/jdtls/workspace/' .. project_name
    },
    root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),

    settings = {
        redhat = {
            telemetry = {
                enabled = false
            }
        },
        java = {
            home = "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home",
            inlayHints = {
                parameterNames = {
                    enabled = "all",
                },
            },
            project = {
                referencedLibraries = {
                    '/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home/jmods/javafx.base.jmod',
                    '/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home/jmods/javafx.controls.jmod',
                    '/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home/jmods/javafx.fxml.jmod',
                    '/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home/jmods/javafx.graphics.jmod',
                    '/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home/jmods/javafx.media.jmod',
                    '/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home/jmods/javafx.swing.jmod',
                    '/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home/jmods/javafx.web.jmod',
                },
            },
            implementationCodeLens = "all",
            referencesCodeLens = {
                enabled = true,
            },
            symbols = {
                includeSourceMethodDeclarations = true,
            },
        },

    },
    capabilities = capabilities,

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this

    init_options = {
        bundles = bundles
    },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require("inlay-hints").setup()
require("jdtls").start_or_attach(config)

vim.api.nvim_buf_create_user_command(0, "JdtTestMethod",
    "lua require(\"jdtls\").test_nearest_method()",
    {})
vim.api.nvim_buf_create_user_command(0, "JdtTestClass",
    "lua require(\"jdtls\").test_class()",
    {})
vim.api.nvim_buf_create_user_command(0, "JdtPickTest",
    "lua require(\"jdtls\").pick_test()",
    {})
vim.api.nvim_buf_create_user_command(0, "JdtTestGotoSubjects",
    "lua require(\"jdtls.tests\").goto_subjects()",
    {})
vim.api.nvim_buf_create_user_command(0, "JdtTestGenerate",
    "lua require(\"jdtls\").generate()",
    {})
