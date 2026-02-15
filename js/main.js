/**
 * NeoClinic Health - Landing Page
 * Formulário de Apresentação Estratégica
 */

const API_LEAD_URL = 'https://www.neoclinichealth.com.br/api/lead.php';
const LANDING_PAGE_ID = 'lp';

document.addEventListener('DOMContentLoaded', function () {
    const contactForm = document.getElementById('contactForm');
    const successMessage = document.getElementById('successMessage');

    if (contactForm && successMessage) {
        contactForm.addEventListener('submit', function (e) {
            e.preventDefault();

            const btn = contactForm.querySelector('button[type="submit"]');
            const originalText = btn.textContent;
            btn.disabled = true;
            btn.textContent = 'Enviando...';

            const formData = {
                landing_page: LANDING_PAGE_ID,
                nome: contactForm.querySelector('[name="nome"]').value.trim(),
                email: contactForm.querySelector('[name="email"]').value.trim(),
                telefone: contactForm.querySelector('[name="telefone"]').value.trim(),
                clinica: contactForm.querySelector('[name="clinica"]').value.trim(),
                profissionais: contactForm.querySelector('[name="profissionais"]').value.trim(),
                faturamento: contactForm.querySelector('[name="faturamento"]').value,
                cidade: contactForm.querySelector('[name="cidade"]').value.trim()
            };

            fetch(API_LEAD_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(formData)
            })
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    if (data.success) {
                        contactForm.classList.add('hidden');
                        successMessage.classList.remove('hidden');
                    } else {
                        alert(data.message || 'Erro ao enviar. Tente novamente.');
                        btn.disabled = false;
                        btn.textContent = originalText;
                    }
                })
                .catch(function () {
                    alert('Erro de conexão. Tente novamente.');
                    btn.disabled = false;
                    btn.textContent = originalText;
                });
        });
    }
});
