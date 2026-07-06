import { Controller } from "@hotwired/stimulus"

// Gere a seleção de fotografias na landing page: contador, pré-visualizações
// e estado do botão de envio.
export default class extends Controller {
  static targets = ["input", "prompt", "count", "previews", "submit", "submitLabel"]

  static MAX_PREVIEWS = 8

  update() {
    const files = this.inputTargets.flatMap((input) => Array.from(input.files || []))

    this.previewsTarget.innerHTML = ""

    if (files.length === 0) {
      this.promptTarget.classList.remove("hidden")
      this.countTarget.classList.add("hidden")
      this.previewsTarget.classList.add("hidden")
      this.previewsTarget.classList.remove("grid")
      this.submitTarget.disabled = true
      return
    }

    this.promptTarget.classList.add("hidden")
    this.countTarget.classList.remove("hidden")
    this.countTarget.textContent =
      files.length === 1 ? "1 fotografia selecionada" : `${files.length} fotografias selecionadas`

    this.previewsTarget.classList.remove("hidden")
    this.previewsTarget.classList.add("grid")

    files.slice(0, this.constructor.MAX_PREVIEWS).forEach((file) => {
      const img = document.createElement("img")
      img.src = URL.createObjectURL(file)
      img.onload = () => URL.revokeObjectURL(img.src)
      img.className = "aspect-square w-full rounded-lg object-cover shadow"
      this.previewsTarget.appendChild(img)
    })

    const remaining = files.length - this.constructor.MAX_PREVIEWS
    if (remaining > 0) {
      const more = document.createElement("div")
      more.textContent = `+${remaining}`
      more.className =
        "flex aspect-square w-full items-center justify-center rounded-lg bg-sage-200 text-lg text-sage-800"
      this.previewsTarget.appendChild(more)
    }

    this.submitTarget.disabled = false
  }

  submitting() {
    this.submitTarget.disabled = true
    this.submitLabelTarget.textContent = "A enviar… aguardem, por favor"
  }
}
