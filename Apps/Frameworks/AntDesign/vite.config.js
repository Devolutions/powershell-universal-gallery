import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react-swc';
export default defineConfig({
    plugins: [react()],
    build: {
        outDir: 'dist',
        emptyOutDir: true,
        sourcemap: true,
        cssCodeSplit: false,
        rollupOptions: {
            output: {
                entryFileNames: 'assets/antdesign-framework.js',
                chunkFileNames: 'assets/[name]-[hash].js',
                assetFileNames: function (_a) {
                    var name = _a.name;
                    if (name === null || name === void 0 ? void 0 : name.endsWith('.css')) {
                        return 'assets/antdesign-framework.css';
                    }
                    return 'assets/[name]-[hash][extname]';
                },
            },
        },
    },
});
