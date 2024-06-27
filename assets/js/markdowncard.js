Vue.component("markdown-card", {
    template: `
        <q-card >
            <div style="padding:15px;padding-right:30px; padding-top:5px">
            <h6>{{ title }}</h6>
                <!-- Display slot content if available, otherwise display prop content -->
                <md-block :key="contentKey">
                    <slot v-if="hasSlotContent">{{ text }}</slot>
                    <template v-else>{{ text }}</template>
                </md-block>
            </div>
            <button style="position: absolute; top: 0; right: 0; background: none; border: none; cursor: pointer;" @click="copyToClipboard">
                <q-icon name="content_copy" color="black" />
            </button>
        </q-card>
    `,
    props: {
        text: {
            type: String,
            default: ''
        },
        title: {
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
        copyToClipboard() {
            const content = this.extractContent();
            if (!content) return;
            const el = document.createElement('textarea');
            el.value = content;
            el.setAttribute('readonly', '');
            el.style.position = 'absolute';
            el.style.left = '-9999px';
            document.body.appendChild(el);
            el.select();
            document.execCommand('copy');
            document.body.removeChild(el);
        },
        extractContent() {
            if (this.hasSlotContent && this.$slots.default[0].text) {
                return this.$slots.default[0].text.trim();
            }
            return this.text;
        }
    }
});
