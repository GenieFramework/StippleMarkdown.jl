Vue.component("markdown-text", {
    template: `
            <div >
                <!-- Display slot content if available, otherwise display prop content -->
                <md-block :key="contentKey">
                    <slot v-if="hasSlotContent">{{ text }}</slot>
                    <template v-else>{{ text }}</template>
                </md-block>
            </div>
    `,
    props: {
        text: {
            type: String,
            default: ''
        }
    },
    computed: {
        contentKey() {
            return this.extractContent().split('').reduce((a, b) => {
                a = ((a << 5) - a) + b.charCodeAt(0);
                return a & a;
            }, 0);
        },
        hasSlotContent() {
            return !!this.$slots.default;
        }
    },
    methods: {
        extractContent() {
            if (this.hasSlotContent && this.$slots.default[0].text) {
                return this.$slots.default[0].text.trim();
            }
            return this.text;
        }
    }
});
