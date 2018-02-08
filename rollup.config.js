import node_resolve from 'rollup-plugin-node-resolve';

export default {
    input: './src/Main.bs.js',
    output: {
        file: './release/main.js',
        format: 'iife'
    },
    plugins: [
        node_resolve({module: true, browser: true})
    ],
    name: 'starter',
    watch: {
        clearScreen: false
    }
}
