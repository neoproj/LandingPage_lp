/**
 * NeoClinic Health 3.7.0 - Landing Page
 * Scripts principais: formulário e gráficos
 */

/* ============================================
   Formulário de Contacto
   ============================================ */
document.addEventListener('DOMContentLoaded', function () {
    const contactForm = document.getElementById('contactForm');
    const successMessage = document.getElementById('successMessage');

    if (contactForm && successMessage) {
        contactForm.addEventListener('submit', function (e) {
            e.preventDefault();
            contactForm.classList.add('hidden');
            successMessage.classList.remove('hidden');
        });
    }

    initCharts();
    initReadinessGauge();
});

/* ============================================
   Gráficos (Chart.js)
   ============================================ */
function initCharts() {
    if (typeof Chart === 'undefined') return;

    Chart.defaults.font.family = "'Inter', sans-serif";
    Chart.defaults.color = '#94a3b8';

    const palette = {
        cyan: '#06b6d4',
        emerald: '#10b981',
        slate: '#0f172a'
    };

    const tooltipConfig = {
        plugins: {
            tooltip: {
                callbacks: {
                    title: function (items) {
                        const item = items[0];
                        let label = item.chart.data.labels[item.dataIndex];
                        return Array.isArray(label) ? label.join(' ') : label;
                    }
                }
            }
        }
    };

    // Gráfico de Dispersão - IA
    const ctxAI = document.getElementById('aiScatterChart');
    if (ctxAI) {
        new Chart(ctxAI.getContext('2d'), {
            type: 'scatter',
            data: {
                labels: wrapLabels(['Início da Jornada', 'Uso Moderado', 'Exploração de Prompt', 'Domínio de IA', 'Mestria Médica']),
                datasets: [{
                    label: 'Poder Decisório vs Tempo',
                    data: [
                        { x: 10, y: 15 },
                        { x: 35, y: 40 },
                        { x: 55, y: 72 },
                        { x: 75, y: 90 },
                        { x: 95, y: 98 }
                    ],
                    backgroundColor: palette.cyan,
                    borderColor: palette.cyan,
                    pointRadius: 8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                ...tooltipConfig
            }
        });
    }

    // Gráfico Financeiro
    const ctxFin = document.getElementById('financialMasteryChart');
    if (ctxFin) {
        new Chart(ctxFin.getContext('2d'), {
            type: 'line',
            data: {
                labels: wrapLabels(['Atual', 'Mês 3', 'Mês 6', 'Mês 9', 'Mês 12']),
                datasets: [
                    {
                        label: 'Lucratividade',
                        data: [100, 130, 180, 240, 310],
                        borderColor: palette.emerald,
                        fill: true,
                        tension: 0.4,
                        backgroundColor: 'rgba(16, 185, 129, 0.05)'
                    },
                    {
                        label: 'Eficiência',
                        data: [70, 85, 92, 95, 99],
                        borderColor: palette.cyan,
                        fill: true,
                        tension: 0.4,
                        backgroundColor: 'rgba(6, 182, 212, 0.05)'
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                ...tooltipConfig
            }
        });
    }
}

/* ============================================
   Gauge de Prontidão (Plotly)
   ============================================ */
function initReadinessGauge() {
    const gaugeEl = document.getElementById('readinessGauge');
    if (!gaugeEl || typeof Plotly === 'undefined') return;

    const palette = { cyan: '#06b6d4', emerald: '#10b981' };

    Plotly.newPlot('readinessGauge', [{
        type: 'indicator',
        mode: 'gauge+number',
        value: 94,
        title: { text: 'Prontidão Digital', font: { size: 16, color: 'white' } },
        number: { font: { color: palette.cyan, size: 40 } },
        gauge: {
            axis: { range: [null, 100], tickcolor: 'white' },
            bar: { color: palette.emerald },
            bgcolor: 'rgba(255,255,255,0.1)',
            threshold: { line: { color: palette.cyan, width: 4 }, value: 94 }
        }
    }], {
        width: 400,
        height: 350,
        margin: { t: 50, b: 0, l: 30, r: 30 },
        paper_bgcolor: 'rgba(0,0,0,0)',
        font: { family: 'Inter, sans-serif' }
    }, { displayModeBar: false, responsive: true });
}

/* ============================================
   Utilitários
   ============================================ */
function wrapLabels(labels, maxLen = 16) {
    if (!Array.isArray(labels)) return labels;
    return labels.map(function (label) {
        if (label.length <= maxLen) return label;
        const words = label.split(' ');
        const lines = [];
        let currentLine = words[0];
        for (let i = 1; i < words.length; i++) {
            if ((currentLine + ' ' + words[i]).length < maxLen) {
                currentLine += ' ' + words[i];
            } else {
                lines.push(currentLine);
                currentLine = words[i];
            }
        }
        lines.push(currentLine);
        return lines;
    });
}
